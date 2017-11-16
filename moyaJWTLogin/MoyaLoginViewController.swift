//
//  ViewController.swift
//  moyaJWTLogin
//

import UIKit
import RxSwift
import Moya_ModelMapper
import Foundation


class MoyaLoginViewController: UIViewController {

    
    var provider: Networking!
    let disposeBag = DisposeBag()

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBAction func pressedLoginButton(_ sender: Any) {
        
        let enteredEmail = "raymondlam1991@gmail.com"
        let enteredPassword = "asdfasdf"

//        let enteredPassword = self.password.text
//        let enteredEmail = self.email.text
        
        
        provider.request(.authenticateUser(username: enteredEmail, password: enteredPassword))
            .debug("authenticateUser", trimOutput: false)
            .map(to: UserAuthenticationTokens.self)
            .subscribe{ event in
                switch event{
                case .next(let object):
                    AuthUser.save(object.access_token, as: .access_token)
                    AuthUser.save(object.refresh_token, as: .refresh_token)
                    
                    let storyboard = UIStoryboard(name: "NonMain", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "LoggedInViewController")
                    self.present(controller, animated: true, completion: nil)
                    
                case .error(let error):
                    print("Error in saving new tokens\(error.localizedDescription)")
//                    let alert = UIAlertAction(title: "Alert", handler: nil)
//                    self.show(alert)
                default:
                    break
                }
                
            }.disposed(by: disposeBag)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        provider = Networking.unauthenticatedDefaultNetworking()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

