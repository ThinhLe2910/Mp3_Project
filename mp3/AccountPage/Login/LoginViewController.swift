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
    var domainName:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        domainName = "http://localhost:3000/"
        lbMessageFromRegister.lineBreakMode = NSLineBreakMode.byWordWrapping
        lbMessageFromRegister.numberOfLines = 0
        self.navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        lbMessageFromRegister.text=""
        txtPassword.text = ""
        txtUsername.text = ""
    }
    @IBAction func btnLogin(_ sender: Any) {
        let username = txtUsername.text!
        let password = txtPassword.text!
        let url = URL(string: domainName + "login")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let paramString = "username=" + username + "&password=" + password
        let postDataString = paramString.data(using: .utf8)
        request.httpBody = postDataString
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let _ = response as?  HTTPURLResponse,
                  error == nil else{
                print("Error from server", error ?? "Error is underfind")
                return
            }
            let jsonDecoder = JSONDecoder()
            let dataInfo = try? jsonDecoder.decode(Result.self, from: data)
            DispatchQueue.main.async {
                if dataInfo?.result == 1{
                    UserDefaults.standard.set(dataInfo?.data, forKey: "token")
                    self.navigationController?.pushViewController(DashboardViewController(), animated: true)
                }else{
                        let aleart = UIAlertController(title: "Notification", message: dataInfo?.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default)
                        aleart.addAction(ok)
                        self.present(aleart,animated: true)
                }
            }
        }.resume()
    }
    @IBAction func btnRegister(_ sender: Any) {
        let registerVC = RegisterViewController()
        registerVC.delegate = self
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    
}
extension LoginViewController : Register_Login_delegate{
    func message(a: String) {
        let aleart = UIAlertController(title: "Notification", message: a, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        aleart.addAction(ok)
        present(aleart,animated: true)
    }
}
