//
//  RegisterViewController.swift
//  mp3
//
//  Created by Thinh on 30/03/2023.
//

import UIKit

class RegisterViewController: UIViewController {
    
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
                let aleart = UIAlertController(title: "Notification", message: value.message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default,handler: { [weak self]  action in
                    if value.result == 1 {
                        self?.navigationController?.popViewController(animated: true)
                    }
                })
                aleart.addAction(ok)
                self.present(aleart,animated: true)
                
            }
        })
    }
    
}
