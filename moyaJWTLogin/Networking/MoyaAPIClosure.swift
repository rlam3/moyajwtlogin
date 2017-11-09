
import Foundation
import Moya

class MoyaAPIClosures{
    
    ///
    static let endpointClosure = { (target: JWTAPI) -> Endpoint<JWTAPI> in
        
        print("Endpoint Closure Config")

        var defaultEndpoint:Endpoint<JWTAPI> = MoyaProvider.defaultEndpointMapping(for: target)
        
        switch target{
        default:
            return defaultEndpoint
        }
    }
    
}
