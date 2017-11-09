//
//  UserProfileViewController.swift
//  moyaJWTLogin
//
//

import UIKit
import Moya_ModelMapper
import RxSwift

class UserProfileViewController: UIViewController {

    
    @IBOutlet weak var accessToken: UILabel!
    @IBOutlet weak var refreshToken: UILabel!
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var info: UILabel!
    
    var provider: Networking!
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.accessToken.text = AuthUser.get(.access_token) as? String
        self.refreshToken.text = AuthUser.get(.refresh_token) as? String
        
        provider = Networking.newDefaultNetworking()

        provider.request(.getUserProfile())
            .map(to: UserProfile.self)
            .debug()
            .subscribe{ event in
                switch event{
                case .next(let object):
                    
                    
                    self.username.text = object.user_full_name
                    
//                    self.info.text = object.eco_footprint.energy as? String
                    
                case .error(let error):
                    
                    print("\(error.localizedDescription)")
                    
                default:
                    break
                }
            }.disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
