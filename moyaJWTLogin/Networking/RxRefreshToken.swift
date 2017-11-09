//
//  RxRefreshToken.swift
//  moyaJWTLogin
//
//

import Foundation
import RxSwift
import Moya
import Moya_ModelMapper
import Cely
//
//extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
//    public func retryWithAuthIfNeeded() -> Single<ElementType> {
//        return retryWhen { e in
//            Observable.zip(e, Observable.range(start: 1, count: 3),
//                           resultSelector: { $1 })
//                .flatMap { i -> PrimitiveSequence<SingleTrait, UserAuthenticationTokens> in
////                    var _xAppToken = XAppToken()
//                    let provider = Networking.newDefaultNetworking()
//                    return provider
//                        .request(.refreshAccessToken())
//                        .filterSuccessfulStatusCodes()
//                        .map(to: UserAuthenticationTokens.self)
//                        .catchError { error in
//                            if case MoyaError.statusCode(let response) = error  {
//                                if response.statusCode == 401 {
//                                    // Logout
//                                    print("Logout")
//                                }
//                            }
//                            return Single.error(error)
//                        }
//                        .flatMap{ access -> PrimitiveSequence<SingleTrait, UserAuthenticationTokens> in
////                            XCGLogger.default.debug(access.accessToken)
////                            XCGLogger.default.debug(access.refreshToken)
//
//                            return Single.just(access)
//                        }
//            }
//        }
//    }
//}

//
//public extension ObservableType where E == Response {
//    /// Tries to refresh auth token on 401 errors and retry the request.
//    /// If the refresh fails, the signal errors.
//    public func retryWithAuthIfNeeded() ->  Observable<Response> {
//        return self.retryWhen{ (e: Observable<Error>) in
//            Observable.zip(e, Observable.range(start: 1, count: 3), resultSelector: { $1 })
//                .flatMap { i in
//                    let provider = Networking.newDefaultNetworking()
//                    return provider.rx.request(.refresh(token: "abc"))
//                        .filterSuccessfulStatusAndRedirectCodes()
//                        .asObservable()
//                        .map(Token.self)
//                        .catchError {  error  in
//                            if case MoyaError.statusCode(let response) = error  {
//                                if response.statusCode == 401 {
//                                    // Logout
//                                    do {
//                                        try User.logOut()
//                                    } catch _ {
//                                        logger.warning("Failed to logout")
//                                    }
//                                }
//                            }
//                            return Observable.error(error)
//                        }.flatMap { token -> Observable<Token> in
//                            do {
//                                try token.saveInRealm()
//                            } catch let e {
//                                logger.warning("Failed to save access token")
//                                return Observable.error(e)
//                            }
//                            return Observable.just(token)
//                    }
//            }
//        }
//    }
//}

