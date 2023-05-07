//
//  InformationViewController.swift
//  mp3
//
//  Created by Thinh on 31/03/2023.
//

import UIKit

class InformationViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtName: UITextField!
    var token:String!
    var browser:AccountInfor!
    var accountAPI:AccountAPIService
    init(accountAPI: AccountAPIService) {
        self.accountAPI = accountAPI
        super.init(nibName: "InformationViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("information deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAccount()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAccount()
    }
    func getAccount(){
        token = UserDefaults.standard.string(forKey: "token")!
        accountAPI.getAccount(token: token) {[weak self] value in
            guard let self = self else{
                return
            }
            DispatchQueue.main.async {
                self.txtName.text = value.data.name
                self.txtUserName.text = value.data.username
                self.txtEmail.text = value.data.email
            }
        }
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        let alert = UIAlertController(title: "Message", message: "Do you want to update Your Information", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { [weak self] action in
            guard let self = self else{
                return
            }
            let name = self.txtName.text!
            let email = self.txtEmail.text!
            let username = self.txtUserName.text!
            self.accountAPI.updateAccount(token: self.token, username: username, email: email, name: name) { [weak self] value in
                guard let self = self else{
                    return
                }
                DispatchQueue.main.async {
                    if value.result == 1{
                        self.notiSuccessfully(a:value.message)
                    }else{
                        let aleart = UIAlertController(title: "Notification", message: value.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default)
                        aleart.addAction(ok)
                        self.present(aleart,animated: true)
                    }
                }
            }
                
        }))
        self.present(alert, animated: true)
    }
    func notiSuccessfully(a:String){
        let alert = UIAlertController(title: "Message", message: a, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
}
