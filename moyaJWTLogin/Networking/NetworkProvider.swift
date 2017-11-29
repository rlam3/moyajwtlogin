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
        
//        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins)
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

struct AuthenticatedNetworking: NetworkingType {
    
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
//        let authPlugin = AccessTokenPlugin(tokenClosure: AuthUser.get(.access_token) as! String)

        return [
            NetworkLoggerPlugin(verbose:true),
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
                let authProvider = AuthenticatedNetworking.refreshTokenAuthorizedNetworking()
                authProvider.request(.refreshAccessToken())
                    .filterSuccessfulStatusCodes()
                    .debug()
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
        
        print("Entering.... unauthenticatedDefaultNetworking")
        return Networking(provider: OnlineProvider<JWTAPI>())
    }
    
    static func refreshTokenAuthorizedNetworking() -> AuthenticatedNetworking {
        print("Entering.... refreshTokenDefaultNetworking")
        return AuthenticatedNetworking(provider: OnlineProvider<JWTAPI>(
//            requestClosure: endpointResolver(),
            plugins: self.plugins
        ))
    }
    
    static func authorizedNetworking() -> AuthenticatedNetworking {
        print("Entering.... authorizedNetworking")
        return AuthenticatedNetworking(provider: OnlineProvider<JWTAPI>(
            plugins: [
                NetworkLoggerPlugin(verbose:true),
            ]
        ))
    }
    
    // FIXME: During production... Network Logger should be turned off?

//    static func newDefaultNetworking() -> Networking {
//        print("Entering.... New Default Networking")
//        return AuthenticatedNetworking(provider: OnlineProvider<JWTAPI>(
//            plugins: self.plugins
//        ))
//    }

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


fileprivate extension AuthenticatedNetworking{
    
    func RequiresAuthenticationRequest() -> Observable<String> {

        let s_jwt = SmartAccessToken() 
        if s_jwt.isExpiredOrExpiringSoon == false{
            return .just(s_jwt.jwt.string)
        }else{
//            let provider = AuthenticatedNetworking.refreshTokenAuthorizedNetworking()
            return provider.request(.refreshAccessToken())
                .debug()
                .filterSuccessfulStatusCodes()
                .map(to: UserAuthenticationTokens.self)
                .do(onNext:{
                    AuthUser.save([
                        .access_token : $0.access_token,
                        .refresh_token : $0.refresh_token
                    ])
                }).map{ (token) -> String in
//                    print("\(String(describing: AuthUser.get(.access_token)))")
                    return AuthUser.get(.access_token) as! String
                }
        }
        
    }
}



// "Public" interfaces
extension Networking {

    func request(_ token: JWTAPI) -> Observable<Moya.Response> {

        return self.provider.request(token).asObservable()

    }
}


extension AuthenticatedNetworking {
    
    func request(_ token: JWTAPI) -> Observable<Moya.Response> {
        
        let actualRequest = provider.request(token)
        
        // This helps break the refresAccessToken Infinite Loop
        switch token {
        case .refreshAccessToken:
            return self.provider.request(token).asObservable()
        default:
            return self.RequiresAuthenticationRequest().flatMap{ _ in actualRequest}

        }

    }
}



//
//private func newProvider<T>(plugins: [PluginType]) -> OnlineProvider<T> {
//    return OnlineProvider(plugins: plugins)
//}

