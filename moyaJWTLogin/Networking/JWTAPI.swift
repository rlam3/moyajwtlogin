//
//  JWTAPI.swift
//  moyaJWTLogin
//
//

import Foundation
import Moya

public enum JWTAPI {
    
    case authenticateUser(username: String, password: String)
    case refreshAccessToken()
    
    case getUserProfile()

    public static let apiVersion = "v1.0"

}


extension JWTAPI: TargetType, AccessTokenAuthorizable{
    public var headers: [String : String]? {
        switch self {
        case .authenticateUser:
            return [
                "Referer":baseURL.absoluteString,
                "Content-type":"application/json"
            ]
        case .refreshAccessToken:
            return
                ["Authorization": "Bearer \(AuthUser.get(.refresh_token) ?? "")"]
        default:
            return [
                "Authorization": "Bearer \(AuthUser.get(.access_token) ?? "")",
//                "Content-type":"application/json"
            ]
        }
//        return nil
    }
    
    
    public var authorizationType: AuthorizationType {
        switch self {
        case .authenticateUser:
            return .none
        default:
            return .bearer
        }
    }
    

    ///
    public var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .authenticateUser:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
    
    public var task: Task {
        let encoding: Moya.ParameterEncoding
        switch self.method {
        case .post:
            encoding = JSONEncoding.default
        default:
            encoding = URLEncoding.default
        }
        if let requestParameters = parameters {
            return .requestParameters(parameters: requestParameters, encoding: encoding)
        }
        return .requestPlain
    }

    ///
    public var requiresRefererHeader: Bool{
        switch self.method {
        case .post, .put:
            return true
        default:
            return false
        }
    }

    ///
    public var baseURL:URL{
        get{
            let url:String = Config.sharedInstance.apiEndpoint()
            return URL(string:url)!
        }
    }

    ///
    public var path: String {
        switch self {
        case .authenticateUser:
            return "/\(JWTAPI.apiVersion)/auth/"
        case .refreshAccessToken:
            return "/\(JWTAPI.apiVersion)/token/refresh/"
        case .getUserProfile:
            return "/\(JWTAPI.apiVersion)/user/profile/"
        }
    }

    ///
    public var method: Moya.Method {
        switch self {
        case .authenticateUser,
             .refreshAccessToken:
            return .post
        default:
            // All requests are GET unless specified otherwise
            return .get
        }

    }

    ///
    public var parameters: [String: Any]? {
        switch self {
        case .authenticateUser(let username, let password):
            return [
                // "client_key": APIkey.sharedInstance.key ?? ""
                // "client_secret": APIKey.sharedInstance.secret ?? ""
                // "grant_type": "credentials"
                "username": username,
                "password": password,
            ]
        default:
            return nil
        }
    }





    ///FIXME: NEED to add stubbed responses
    public var sampleData: Data {
        switch self {
        case .authenticateUser:
            return stubbedResponse("AuthenticateUser")
        case .refreshAccessToken:
            return stubbedResponse("RefreshToken")
        default:
            return "None".UTF8EncodedData
        }
    }


    public var multipartBody: [MultipartFormData]? {
        // Optional
        return nil
    }

}



// MARK: - Helpers
private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
    var UTF8EncodedData: Data {
        return self.data(using: String.Encoding.utf8)!
    }
}


// MARK: - Provider support

func stubbedResponse(_ filename: String) -> Data! {

    @objc class TestClass: NSObject { }

    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}

func url(_ route: TargetType) -> String {

    return route.baseURL.appendingPathComponent(route.path).absoluteString
}
