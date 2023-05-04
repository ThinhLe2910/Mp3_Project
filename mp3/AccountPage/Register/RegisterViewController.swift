//
//  RegisterViewController.swift
//  mp3
//
//  Created by Thinh on 30/03/2023.
//

import UIKit
protocol Register_Login_delegate{
    func message(a:String)
}
class RegisterViewController: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    var delegate:Register_Login_delegate?
    var domainName:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        domainName = "http://localhost:3000/"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        let username = txtUserName.text!
        let password = txtPassword.text!
        let email = txtEmail.text!
        let name = txtName.text!
        let confirmPassord = txtConfirmPassword.text!
        let url = URL(string: domainName + "register")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let paramString = "username=" + username + "&name=" + name + "&password=" + password + "&email=" + email + "&confirmPassword=" + confirmPassord
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
                   
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.message(a: dataInfo?.message ?? "")
                }else{
                    let aleart = UIAlertController(title: "Notification", message: dataInfo?.message, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default)
                    aleart.addAction(ok)
                    self.present(aleart,animated: true)
                }
            }
            
        }.resume()
        
    }
    
}
