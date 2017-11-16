//
//  Networking.swift
//  moyaJWTLogin
//
//

import Foundation
import Moya
import Result
import RxSwift
import JWTDecode

class OnlineProvider<Target>: MoyaProvider<Target> where Target: TargetType {

    fileprivate let online: Observable<Bool>
    fileprivate let provider: MoyaProvider<Target>
    
    init(
        endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
        requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider.defaultRequestMapping,
        stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
        manager: Manager = MoyaProvider<Target>.defaultAlamofireManager(),
        plugins: [PluginType] = [],
        online: Observable<Bool> = connectedToInternetOrStubbing()) {
        
        self.online = online
        self.provider = MoyaProvider(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins)
        
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins)
    }

    func request(_ token: Target) -> Observable<Moya.Response> {
        let actualRequest = provider.rx.request(token)
//        let actualRequest = self.request(token)
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

    typealias T = JWTAPI
    var provider: OnlineProvider<JWTAPI>

}


extension NetworkingType {
    
    func smartTokenClosure(_ token: JWTAPI) -> String {
        switch token {
        case .authenticateUser:
            return ""
        default:
            return AuthUser.get(.access_token) as! String
        }
    }
    
}

// Static methods
extension NetworkingType {
    
    static var plugins: [PluginType] {

//        let authPlugin = AccessTokenPlugin(tokenClosure: smartTokenClosure(self.T) )
        let authPlugin = AccessTokenPlugin(tokenClosure: AuthUser.get(.access_token) as! String)

        return [
            NetworkLoggerPlugin(verbose:true),
            authPlugin
        ]
    }

    static var refreshTokenPlugins: [PluginType] {
        let authPlugin = AccessTokenPlugin(tokenClosure: AuthUser.get(.refresh_token) as! String)
        
        return [
            NetworkLoggerPlugin(verbose:true),
            authPlugin
        ]

    }
    
    // (Endpoint<Target>, NSURLRequest -> Void) -> Void
    static func endpointResolver<T>() -> MoyaProvider<T>.RequestClosure where T: TargetType {
        return { (endpoint, closure) in
            
            var request = try! endpoint.urlRequest()
            request.httpShouldHandleCookies = false
            let disposeBag = DisposeBag()

            let s_jwt = SmartAccessToken()
            if s_jwt.isExpiredOrExpiringSoon{
                let authProvider = Networking.refreshTokenDefaultNetworking()
                authProvider.request(.refreshAccessToken())
                    .filterSuccessfulStatusCodes()
                    .map(to: UserAuthenticationTokens.self)
                    .subscribe{ event in
                        switch event{
                        case .next(let object):
                            AuthUser.save([
                                .access_token : object.access_token,
                                .refresh_token: object.refresh_token
                            ])
                            closure(.success(request))
                        case .error(let error):
                            print("\(error.localizedDescription)")
//                            closure(.failure(error))
                        default: break
                        }
                        
                    }.disposed(by: disposeBag)
            }else{
                closure(.success(request))
                return
            }
        }
    }
    
    static func unauthenticatedDefaultNetworking() -> Networking {
        
        print("Entering.... Unauth Default Networking")
        return Networking(provider: OnlineProvider<JWTAPI>())
    }
    
    static func refreshTokenDefaultNetworking() -> Networking {
        
        print("Entering.... refreshTokenDefaultNetworking")
        return Networking(provider: OnlineProvider<JWTAPI>(
//            plugins: refreshTokenPlugins
            requestClosure: self.endpointResolver()
        ))
    }
    
    // FIXME: During production... Network Logger should be turned off?

    static func newDefaultNetworking() -> Networking {
        print("Entering.... New Default Networking")
        return Networking(provider: OnlineProvider<JWTAPI>(
            requestClosure: self.endpointResolver(),
            plugins: self.plugins
        ))
    }

//    static func newStubbingNetworking() -> Networking {
//        return Networking(provider: OnlineProvider<JWTAPI>(
//            endpointClosure: MoyaProvider.defaultEndpointMapping,
//            stubClosure: MoyaProvider<JWTAPI>.immediatelyStub,
//            plugins:[NetworkLoggerPlugin(verbose:true)],
//            online: .just(false)))
//    }


    static func APIKeysBasedStubBehaviour<T>(_: T) -> Moya.StubBehavior {
        return .immediate
    }
}


fileprivate extension Networking{
    
    func RequiresAuthenticationRequest() -> Observable<String> {
        
        let njwt_string = AuthUser.get(.access_token) as! String
        
//        guard let jwt: JWT = try! decode(jwt: njwt_string) else {
//
//        }

        return .just(njwt_string)

//        return .just(AuthUser.get(.access_token))
        
//
//        // If access token is valid
//        if AuthManager.shared.expiredAccessToken == false{
//            return .just(jwt)
//        }else{
//
//            // Refresh access token
//            return request(.refreshAccessToken())
//                .filterSuccessfulStatusCodes()
//                .map(RefrehedAccessToken.self)
//                .do(onNext: {
//                    print("Saved new access token")
//                    $0.save()
//                }).map{ (token) -> String in
//                    // Get new access token that was just saved
//                    return AuthManager.shared.accessToken!
//            }
//        }
        
    }
}



// "Public" interfaces
extension Networking {

    func request(_ token: JWTAPI) -> Observable<Moya.Response> {
        let actualRequest = provider.rx.request(token)
        return actualRequest.asObservable()
//        return flatMap{ _ in actualRequest }
//        return self.RequiresAuthenticationRequest().flatMap{ _ in actualRequest}
        
    }

}



//
//private func newProvider<T>(plugins: [PluginType]) -> OnlineProvider<T> {
//    return OnlineProvider(plugins: plugins)
//}

