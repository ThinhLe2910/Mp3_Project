//
//  RegisterViewController.swift
//  mp3
//
//  Created by Thinh on 30/03/2023.
//

import UIKit

class RegisterViewController: UIViewController {
    
    
    var handlerLogin: ((_ message: String) -> Void)?
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    var accountAPI:AccountAPIService
    
    init(accountAPI: AccountAPIService) {
        self.accountAPI = accountAPI
        super.init(nibName: "RegisterViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("register deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        let username = txtUserName.text!
        let password = txtPassword.text!
        let email = txtEmail.text!
        let name = txtName.text!
        let confirmPassword = txtConfirmPassword.text!
        accountAPI.register(username: username, password: password, email: email, name: name, confirmPassword: confirmPassword, completionHandler: { [weak self] value in
            guard let self = self else{
                return
            }
            DispatchQueue.main.async {
                if value.result == 1{
                    self.handlerLogin?(value.message)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    let aleart = UIAlertController(title: "Notification", message: value.message, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default)
                    aleart.addAction(ok)
                    self.present(aleart,animated: true)
                }
            }
        })
    }
    
}
