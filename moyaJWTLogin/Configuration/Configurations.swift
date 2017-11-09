//
//  Configurations.swift

import Foundation

class Config: NSObject {
    // Singleton instance
    static let sharedInstance = Config()
    
    var configs: NSDictionary!
    
    override init() {
        // Take current configuration value from the `Info.plist`. `Config` is the name of the Info plist key (fig. 7).
        //`currentConfiguration` Can be `Debug`, `Staging`, or whatever you created in previous steps.
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Config")!
        
        // Loads `Config.plist` and stores it to dictionary. The configuration names are the keys of the `configs` dictionary.
        let path = Bundle.main.path(forResource: "EnvironmentVariables", ofType: "plist")!
        configs = NSDictionary(contentsOfFile: path)!.object(forKey: currentConfiguration) as! NSDictionary
    }
}



extension Config {
    
    
    func baseURLString() -> String{
        return configs.value(forKey: "BaseURL") as! String
    }
    
    func signUpURLString() -> String{
        return baseURLString() + "user/signup/"
    }
    
    func privacyURL() -> URL{
        return URL(string: baseURLString() + "legal/privacy")!
    }

    func tosURL() -> URL{
        return URL(string: baseURLString() + "legal/terms")!
    }

    
    func apiEndpointURL() -> URL{
        
        let endpointString = self.apiEndpoint()
        return URL(string: endpointString)!
        
    }
    
    func aboutURLString() -> String{
        return baseURLString() + "about"
    }
    
    func contactUsURLString() -> String{
        return baseURLString() + "contact_us"
    }
    
    
    func forgotUserPassword() -> String {
        return configs.value(forKey: "ForgotPasswordURL") as! String
    }
    
    func apiEndpoint() -> String {
        return configs.object(forKey: "APIEndpointURL") as! String
    }
    
    func loggingLevel() -> String {
        return configs.object(forKey: "loggingLevel") as! String
    }
    

}
