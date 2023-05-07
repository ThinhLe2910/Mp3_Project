//
//  ChangePasswordViewController.swift
//  mp3
//
//  Created by Thinh on 08/04/2023.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    var token:String!
    @IBOutlet weak var txtNewPas: UITextField!
    @IBOutlet weak var txtComfirmPassword: UITextField!
    @IBOutlet weak var txtCurrentPassword: UITextField!
    var accountAPI:AccountAPIService
    
    init(accountAPI: AccountAPIService) {
        self.accountAPI = accountAPI
        super.init(nibName: "ChangePasswordViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("change password deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        token = UserDefaults.standard.string(forKey: "token")!
        // Do any additional setup after loading the view.
    }


    @IBAction func btnChangePassword(_ sender: Any) {
        let alert = UIAlertController(title: "Message", message: "Do you want to change password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: {[weak self] action in
            guard let self = self else{
                return
            }
            let newpass = self.txtNewPas.text!
            let current = self.txtCurrentPassword.text!
            let comfirm = self.txtComfirmPassword.text!
            self.accountAPI.changePassword(token: self.token, newpass: newpass, current: current, comfirm: comfirm, completionHandler: { [weak self] value in
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
            })
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
