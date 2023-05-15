//
//  LoginViewController.swift
//  mp3
//
//  Created by Thinh on 30/03/2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var lbMessageFromRegister: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    
    var accountAPI:AccountAPIService
    var recentAPI: RecentApiService
    init(accountAPI: AccountAPIService,recentAPI: RecentApiService) {
        self.accountAPI = accountAPI
        self.recentAPI = recentAPI
        super.init(nibName: "LoginViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("login deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        lbMessageFromRegister.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbMessageFromRegister.numberOfLines = 0
        self.navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view.
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lbMessageFromRegister.text=""
        txtPassword.text = ""
        txtUsername.text = ""
    }
    @IBAction func btnLogin(_ sender: Any) {
        let username = txtUsername.text!
        let password = txtPassword.text!
        accountAPI.login(username: username, password: password,completionHandler: { [weak self] value in
            guard let self = self else{
                return
            }
            DispatchQueue.main.async {
                if value.result == 1{
                    UserDefaults.standard.set(value.data, forKey: "token")
                    self.navigationController?.pushViewController(DashboardViewController(accountAPI: self.accountAPI, recentApi: self.recentAPI), animated: true)
                }else{
                    let aleart = UIAlertController(title: "Notification", message: value.message, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default)
                    aleart.addAction(ok)
                    self.present(aleart,animated: true)
                }
            }
        })
            
    }
    @IBAction func btnRegister(_ sender: Any) {
        self.navigationController?.pushViewController(RegisterViewController(accountAPI: accountAPI), animated: true)
    }
    
    
}
