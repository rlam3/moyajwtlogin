//
//  MidoriMoya.swift
//  Midori
//
//  Created by Raymond Lam on 9/1/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation
import Moya
import Locksmith
import Result

public enum MidoriMoyaAPI {
    case getCSRF()
    
    // Pass
    case authenticateUser(username: String, password: String)
    case refreshAccessToken()

    case getFirstUserFeed(page:Int,limit:Int)
    case getUserFeed(page: Int, limit: Int)
    
    case getOrganization(organizationUUID:String)
    
    case getOrganizationRegion(organizationUUID: String)
    
    case getRegionalPublications(regionID:Int, page:Int, limit:Int)
    
    case getOrganizationLocations(organizationUUID: String, regionID: Int)
    
    case postUserSubscriptionToggle(organizationUUID:String, updates:[Dictionary<String,AnyObject>])
    
    case postUserPublicationView(publicationID:Int)
    
    case searchForTerm(term:String)

    case getUserProfile()
    
    public static let apiVersion = "v1.0"
}


extension MidoriMoyaAPI: TargetType{
    
    ///
    public var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .postUserSubscriptionToggle,
             .authenticateUser,
             .postUserPublicationView:
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
    public var requiresAccessToken: Bool{
        switch self {
        case .authenticateUser,
             .getCSRF:
            return false
        default:
            return true
        }
    }
    
    public var requiresCSRFToken:Bool{
        switch self.method {
        case .post, .put:
            return true
        default:
            return false
        }
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
    public var headers: [String:String]? {
        switch self {
        case .authenticateUser:
            return [
                "X-CSRFToken":AuthManager.shared.csrf_token!,
                "Referer":baseURL.absoluteString
            ]
        case .postUserSubscriptionToggle:
            return [
                "X-CSRFToken":AuthManager.shared.csrf_token!,
                "Authorization":AuthManager.shared.accessTokenWithBearer!,
                "Referer":baseURL.absoluteString
            ]
        case .refreshAccessToken:
            return [
                "X-CSRFToken":AuthManager.shared.csrf_token!,
                "Authorization":AuthManager.shared.refreshTokenWithBearer!,
                "Referer":baseURL.absoluteString
            ]
        case .getCSRF:
            return nil
        default:
            // Authorized GET requests
            return ["Authorization":AuthManager.shared.accessTokenWithBearer!]
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
            return "/\(MidoriMoyaAPI.apiVersion)/auth/"
        case .refreshAccessToken:
            return "/\(MidoriMoyaAPI.apiVersion)/token/refresh/"
        case .getCSRF:
            return "/\(MidoriMoyaAPI.apiVersion)/csrf_token/"
        case .getFirstUserFeed:
            return "/\(MidoriMoyaAPI.apiVersion)/user/feed/"
        case .getUserFeed:
            return "/\(MidoriMoyaAPI.apiVersion)/user/feed/"
        case .getOrganization(_):
            return "/\(MidoriMoyaAPI.apiVersion)/organization"
        case .getOrganizationRegion(_):
            return "/\(MidoriMoyaAPI.apiVersion)/organization/regions"
        case .getOrganizationLocations:
            return "/\(MidoriMoyaAPI.apiVersion)/organization/locations/"
        case .getRegionalPublications(_,_,_):
            return "/\(MidoriMoyaAPI.apiVersion)/region/publication/"
        case .postUserSubscriptionToggle(_,_):
            return "/\(MidoriMoyaAPI.apiVersion)/organization/regions/user_subscription"
        case .postUserPublicationView(_):
            return "/\(MidoriMoyaAPI.apiVersion)/publication/view/create"
        case .getUserProfile:
            return "/\(MidoriMoyaAPI.apiVersion)/user/profile/"
        case .searchForTerm(_):
            return "/\(MidoriMoyaAPI.apiVersion)/search"
        }
    }
    
    ///
    public var method: Moya.Method {
        switch self {
        case .authenticateUser,
             .postUserSubscriptionToggle,
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
        case .getFirstUserFeed(let page, let limit):
            return [
                "page": page as Any,
                "limit": limit as Any,
            ]
        case .getUserFeed(let page, let limit):
            return[
                "page": page as Any,
                "limit": limit as Any,
            ]
        case .getOrganization(let organizationUUID):
            return [
                "organization_uuid": organizationUUID
            ]
        case .getOrganizationRegion(let organizationUUID):
            return [
                "organization_uuid": organizationUUID as Any,
            ]
        case .getOrganizationLocations(let organizationUUID, let regionID):
            return [
                "organization_uuid": organizationUUID,
                "region_id": regionID
            ]
        case .getRegionalPublications(let regionID, let page, let limit):
            return [
                "region_id": regionID,
                "page": page,
                "limit": limit
            ]
        case .postUserSubscriptionToggle(let organizationUUID, let updates):
            return [
                "organization_uuid": organizationUUID as Any,
                "regions": updates as Any,
            ]
        case .postUserPublicationView(let publicationID):
            return [
                "publicationID": publicationID as Any,
            ]
        case .searchForTerm(let term):
            return [
                "term": term
            ]
        case .getCSRF:
            return nil
        default:
            return nil
        }
    }
    
    

    
    
    ///FIXME: NEED to add stubbed responses
    public var sampleData: Data {
        switch self {
        case .getCSRF:
            return stubbedResponse("X-CSRFToken")
        case .authenticateUser:
            return stubbedResponse("AuthenticateUser")
        case .refreshAccessToken:
            return stubbedResponse("RefreshToken")
        case .searchForTerm:
            return stubbedResponse("SearchForTerm")
        case .getFirstUserFeed:
            return stubbedResponse("GetFirstUserFeed")
        case .getUserFeed:
            return stubbedResponse("GetFirstUserFeed")
        case .getOrganization:
            return stubbedResponse("GetOrganization")
        case .getOrganizationRegion:
            return stubbedResponse("GetOrganizationRegion")
        case .getOrganizationLocations:
            return stubbedResponse("GetOrganizationLocation")
        case .getRegionalPublications:
            return stubbedResponse("GetFirstUserFeed")
        case .getUserProfile:
            return stubbedResponse("GetUserProfile")
        case .postUserPublicationView:
            return stubbedResponse("PostPublicationView")
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

