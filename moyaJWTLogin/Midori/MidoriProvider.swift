import Foundation
import Moya
import RxSwift
import Alamofire

class OnlineProvider<Target>: MoyaProvider<Target> where Target: TargetType {
    
    fileprivate let online: Observable<Bool>
    fileprivate let provider: MoyaProvider<Target>
    fileprivate let authToken: OAuthToken
    
    init(
        endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
         manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
         plugins: [PluginType] = [],
         online: Observable<Bool> = connectedToInternetOrStubbing()) {
        
        self.online = online
        self.provider = MoyaProvider(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins)

//        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins)
    }
    
    func request(_ token: Target) -> Observable<Moya.Response> {
        let actualRequest = provider.rx.request(token)
        return online
//            .ignore(value: false)  // Wait until we're online
            .take(1)        // Take 1 to make sure we only invoke the API once.
            .flatMap { _ in // Turn the online state into a network request
                return actualRequest
        }
        
    }
}


protocol NetworkingType {
    associatedtype T: TargetType
    var provider: OnlineProvider<T> { get }
}

struct Networking: NetworkingType {
    typealias T = MidoriMoyaAPI
    let provider: OnlineProvider<MidoriMoyaAPI>
}

// Static methods
extension NetworkingType {
    
    
    static var plugins: [PluginType] {
        return [NetworkLoggerPlugin(verbose:true),]
    }

    // FIXME: During production... Network Logger should be turned off?

    static func newDefaultNetworking() -> Networking {
        return Networking(provider: OnlineProvider<MidoriMoyaAPI>(
            endpointClosure:MoyaAPIClosures.endpointClosure,
            plugins:[NetworkLoggerPlugin(verbose:false)]
        ))
    }
    
    static func newStubbingNetworking() -> Networking {
        return Networking(provider: OnlineProvider<MidoriMoyaAPI>(
            endpointClosure: MoyaAPIClosures.endpointClosure,
            stubClosure: MoyaProvider<MidoriMoyaAPI>.immediatelyStub,
            plugins:[NetworkLoggerPlugin(verbose:true)],
            online: .just(false)))
    }


    static func APIKeysBasedStubBehaviour<T>(_: T) -> Moya.StubBehavior {
        return .immediate
    }
}


fileprivate extension Networking{
    
    func RequiresAuthenticationRequest() -> Observable<String> {
        
        /// This has 3 cases
        
        // 0. token is not present, error out
        // 1. token is not expired, return token
        // 2. token is expired, needs refresh
        
        guard let jwt = AuthManager.shared.accessToken else{
            return .just("No access tokens was found.")
        }
        
        // If access token is valid
        if AuthManager.shared.expiredAccessToken == false{
            return .just(jwt)
        }else{
            
            // Refresh access token
            return request(.refreshAccessToken())
                .filterSuccessfulStatusCodes()
                .map(to: RefrehedAccessToken.self)
                .do(onNext: {
                    print("Saved new access token")
                    $0.save()
                }).map{ (token) -> String in
                    // Get new access token that was just saved
                    return AuthManager.shared.accessToken!
            }
        }
        
    }
}


// "Public" interfaces
extension Networking {
    /// Request to fetch a given target. Ensures that valid XApp tokens exist before making request
    func request(_ token: MidoriMoyaAPI) -> Observable<Moya.Response> {
        
        /// Need to update to rx
        let actualRequest = self.provider.rx.request(token)
        return actualRequest
        
        
//        let actualRequest = self.provider.request(token)
        
        // All Post/put requests require csrf and authentication except .aukthenticateUser/.forgotPassword
        // All gets will only require authentication
        
        // X 0. get - requires no auth, no csrf // getCSRF
        // X 1. get - requiresAuth no CSRF\ //
        // X 2. post - requiresOnlyCSRF == .authenticate/login/forgotpassword
        // 3. post/put - requiresAuth and CSRF // Ex Toggling User subscription, refreshAccessToken
        
//        switch (token.requiresCSRFToken,token.requiresAccessToken) {
//        case (false,false):
//            return actualRequest
//        case (true,false):
//            return RequiresCSRFTokenRequest().flatMap{ _ in actualRequest}
//        case (false,true):
//            return RequiresAuthenticationRequest().flatMap{ _ in actualRequest}
//        case (true,true):
//            // Similar to https://github.com/artsy/eidolon/blob/fdd5981005b1c631d284f89f9a2d7bb808437e0d/Kiosk/Bid%20Fulfillment/BidderNetworkModel.swift#L29-L38
//
//            return RequiresCSRFTokenRequest().flatMap{ _ in
//                self.RequiresAuthenticationRequest().flatMap{ _ in actualRequest}
//            }
//
        }
    
    }

