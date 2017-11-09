//
//  ViewController.swift
//  MidoriApp
//
//  Created by Raymond Lam on 3/9/15.
//  Copyright (c) 2015 Raymond Lam. All rights reserved.
//

import UIKit
import Crashlytics
import Onboard
import FlatUIColors
import Font_Awesome_Swift
import RxSwift
import SafariServices

class LoginViewController: UIViewController, SFSafariViewControllerDelegate, UITextFieldDelegate{

    // MARK: var
    var isFinishedOnboarding: Bool?
    var provider: Networking!
    let disposeBag = DisposeBag()

    // MARK: IBOutlet

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var configurationSetting: UILabel!

    // MARK: IBActions
    
    @IBAction func clickedOnSignup(_ sender: Any) {
        
        let urlString:String = Config.sharedInstance.signUpURLString()
        
        let url: URL = URL(string:urlString)!
        
        let svc = SFSafariViewController(url:url)
        svc.delegate = self
        present(svc, animated: true, completion: nil)
    }
    
    
    @IBAction func clickedOnForgotPassword(_ sender: Any) {
        
        let urlString:String = Config.sharedInstance.forgotUserPassword()
        
        let url: URL = URL(string:urlString)!
        
        let svc = SFSafariViewController(url:url)
        svc.delegate = self
        present(svc, animated: true, completion: nil)
        
    }
    
    
    // MARK: View

    override func viewDidLoad() {

        super.viewDidLoad()

        // If user is logged in and accessToken is not expired
        if UserDefaults.standard.isLoggedIn() && !(AuthManager.shared.isAccessTokenExpired){
            
            print("USER DEFAULT LOGGED IN AND AUTH TOKEN IS NOT EXPIRED!!!")
            self.dismiss(animated: true, completion: nil)
            
        }else{
            // If they are not logged in or if token is expired. User should not go anywhere
            UserDefaults.standard.setIsLoggedIn(value: false)
            configureLoginForm()
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        
        configurationSetting.text = Config.sharedInstance.apiEndpoint() + " :: " + Bundle.main.object(forInfoDictionaryKey: "Config").debugDescription
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.extendedLayoutIncludesOpaqueBars = true
        
        let emailFieldPadding = UIView(frame: CGRect(x: 0,y: 0,width: 15,height: self.emailField.frame.height))
        let passwordFieldPadding = UIView(frame: CGRect(x: 0,y: 0,width: 15,height: self.passwordField.frame.height))
        
        self.emailField.leftView = emailFieldPadding
        self.emailField.leftViewMode = .always
        
        self.passwordField.leftView = passwordFieldPadding
        self.passwordField.leftViewMode = .always
        
        // Reset fields after logout
        self.emailField.text = ""
        self.passwordField.text = ""

    }
    
    func configureLoginForm() {

        NSLog("configureLoginForm")
        
        self.emailField.delegate = self
        self.passwordField.delegate = self

        self.emailField.returnKeyType = .next
        self.passwordField.returnKeyType = .done

        self.emailField.tag = 0
        self.passwordField.tag = 1
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            
            nextField.becomeFirstResponder()
            
        } else {
            
            textField.resignFirstResponder()
            
            return true;
            
        }
        
        return false
    }

    override func viewDidAppear(_ animated: Bool) {
        //http://stackoverflow.com/questions/25523305/checking-the-value-of-an-optional-bool
//        if isFinishedOnboarding ?? false{
//            swiftyBeaverLog.info("Login Screen")
//        }else{
//            presentOnboarding()
//        }
    }

    func presentOnboarding() {

        print("Present Onboarding")

        let firstBody = NSLocalizedString("みどり is Japanese word for 'green'", comment: "Onboarding firstBody")
        let firstPage = OnboardingContentViewController(title: "midori".localized(), body: firstBody, image: UIImage(named: "app_icon_transparent"), buttonText: nil) { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }

        let square_size:CGFloat = 250
        firstPage.iconWidth = square_size
        firstPage.iconHeight = square_size
        firstPage.topPadding = 100
        firstPage.titleLabel.textColor = FlatUIColors.midnightBlue()
        firstPage.bodyLabel.textColor = FlatUIColors.midnightBlue()

        let secondPage = OnboardingContentViewController(title: "Search".localized(), body: "Discover locally sustainable and organic grocers near you.".localized(), image: UIImage(icon: .FASearch, size: CGSize(width: square_size, height: square_size), textColor: FlatUIColors.midnightBlue(), backgroundColor: .white), buttonText: nil) { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }

        secondPage.topPadding = 100
        secondPage.titleLabel.textColor = FlatUIColors.midnightBlue()
        secondPage.bodyLabel.textColor = FlatUIColors.midnightBlue()

        let image3 = UIImage(icon: .FACheckCircleO, size: CGSize(width:square_size,height:square_size), textColor: FlatUIColors.midnightBlue(), backgroundColor: .white)

        let thirdPage = OnboardingContentViewController(title: NSLocalizedString("Follow", comment: "Onboarding Follow title"), body: NSLocalizedString("Tailor your own grocers' updates.", comment: "Onboarding Follow description"), image: image3, buttonText: nil) { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }

        thirdPage.topPadding = 100
        thirdPage.titleLabel.textColor = FlatUIColors.midnightBlue()
        thirdPage.bodyLabel.textColor = FlatUIColors.midnightBlue()

        let image4 = UIImage(icon: .FALeaf, size: CGSize(width: square_size, height: square_size), textColor: FlatUIColors.nephritis(), backgroundColor: .clear)
        let fourthPage = OnboardingContentViewController(title: "Zero-waste".localized(), body: "Digital over paper-based catalogs, reduces your carbon footprint.".localized(), image: image4, buttonText: "Login / Signup".localized()) { () -> Void in
            self.dismiss(animated: true, completion: nil)
            self.isFinishedOnboarding = true
        }

        fourthPage.topPadding = 100
        fourthPage.titleLabel.textColor = FlatUIColors.midnightBlue()
        fourthPage.bodyLabel.textColor = FlatUIColors.midnightBlue()
        fourthPage.actionButton.backgroundColor = FlatUIColors.nephritis()


        // Capture all content views in one view controller
        let onboardingVC:OnboardingViewController = OnboardingViewController(backgroundImage: UIImage.imageWithColor(color: .white), contents: [firstPage, secondPage, thirdPage, fourthPage])

        onboardingVC.shouldFadeTransitions = true
        onboardingVC.shouldMaskBackground = false
        onboardingVC.shouldBlurBackground = false
        onboardingVC.fadePageControlOnLastPage = true
        onboardingVC.pageControl.pageIndicatorTintColor = .darkGray
        onboardingVC.pageControl.currentPageIndicatorTintColor = .lightGray

        onboardingVC.skipButton.titleLabel?.text = "Let's Go"
        onboardingVC.skipButton.setTitleColor(FlatUIColors.dodgerBlue(), for: .normal)
        onboardingVC.allowSkipping = true
        onboardingVC.fadeSkipButtonOnLastPage = true


        onboardingVC.skipHandler = {
            self.dismiss(animated: true, completion: nil)
            self.isFinishedOnboarding = true
        }

        self.present(onboardingVC, animated: true, completion: nil)
    }

    // MARK: IBActions

    @IBAction func loginNew(_ sender: AnyObject){


        let email = "raymondlam1991@gmail.com"
        let password = "asdfasdf"

//        let email = "liger0806@gmail.com"
//        let password = "asdfasdf" 

//        let email = self.emailField.text!
//        let password = self.passwordField.text!

        if ( email.isEmpty || password.isEmpty ) {
            let alert = UIAlertController(
                title: NSLocalizedString("Sign in failed!", comment: "LoginVC Alert Title"),
                message: NSLocalizedString("Please enter Email and Password", comment: "LoginVC Alert Message"),
                preferredStyle: UIAlertControllerStyle.alert
            )
            let alertActionText = NSLocalizedString("OK", comment: "LoginVC Alert Action")
            alert.addAction(UIAlertAction(title: alertActionText, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        // Setup Provider / RxSwift
        setupRx()

        provider.request(.authenticateUser(username: email, password: password))
            .filterSuccessfulStatusCodes()
            .map(to: UserAuthenticationTokens.self)
            .subscribe{ event in
                switch event{
                case .next(let object):
                    
                    // Save new tokens
                    AuthManager.shared.accessToken = object.access_token
                    AuthManager.shared.refreshToken = object.refresh_token

                    // Save email/password to AuthManager
                    // Do not store email and password in keychain !!
//                    AuthManager.shared.email = email
//                    AuthManager.shared.password = password

                    UserDefaults.standard.setIsLoggedIn(value:true)
                    
                    // FIXME: Why is it not dismiss instead of
                    self.performSegue(withIdentifier: "goToUserFeedView", sender: self)
//                    self.dismiss(animated: true, completion: nil)
                    
                    self.navigationController?.isNavigationBarHidden = false

                case .error(let error):
                    
                    /// Crashlytics Error Reporting
                    self.handleError(error: error)
                    
                default:
                    break
                    
                }
                
            }.disposed(by: disposeBag)
    }

    func handleError(error:Error) {
        
        NSLog("Error with Login \(error.localizedDescription)")
        
        // Crashlytics log
        Answers.logLogin(withMethod: "MidoriAPI", success: false, customAttributes: ["Error Description": error.localizedDescription])
        
        let aTitle = NSLocalizedString("Alert", comment: "LoginVC Alert Title")
        let aMessage = NSLocalizedString("Invalid Username or Password. Please try again.", comment: "LoginVC Alert Message")
        
        let alert = UIAlertController(title: aTitle, message: aMessage , preferredStyle: UIAlertControllerStyle.alert)
        
        let aActionTitle = NSLocalizedString("OK", comment: "LoginVC Alert action OK")
        alert.addAction(UIAlertAction(title: aActionTitle, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func setupRx() {
        //Create our proider
        provider = Networking.newDefaultNetworking()
    }
}

public extension UIImage {
    static func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
