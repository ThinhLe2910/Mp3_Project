//
//  ChangePasswordViewController.swift
//  mp3
//
//  Created by Thinh on 08/04/2023.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    var domainName:String!
    var token:String!
    @IBOutlet weak var txtNewPas: UITextField!
    @IBOutlet weak var txtComfirmPassword: UITextField!
    @IBOutlet weak var txtCurrentPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        token = UserDefaults.standard.string(forKey: "token")!
        domainName = "http://localhost:3000/"
        // Do any additional setup after loading the view.
    }


    @IBAction func btnChangePassword(_ sender: Any) {
        let alert = UIAlertController(title: "Message", message: "Do you want to change password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { action in
            let url = URL(string: self.domainName! + "account/change-password")
            let newpass = self.txtNewPas.text!
            let current = self.txtCurrentPassword.text!
            let comfirm = self.txtComfirmPassword.text!
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            let paramString = "token=" + self.token! + "&password=" + newpass
            + "&currentPassword=" + current + "&comfirmPassword=" + comfirm
            let postDataString = paramString.data(using: .utf8)
            request.httpBody = postDataString
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,
                      let _ = response as?  HTTPURLResponse,
                      error == nil else{
                    print("Error from server", error ?? "Error is underfind")
                    return
                }
                print(String(data: data, encoding: .utf8)!)
                let jsonDecoder = JSONDecoder()
                let dataInfo = try? jsonDecoder.decode(Result.self, from: data)
                DispatchQueue.main.async {
                    if dataInfo?.result == 1{
                        self.notiSuccessfully(a:dataInfo!.message)
                    }else{
                        let aleart = UIAlertController(title: "Notification", message: dataInfo?.message, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default)
                        aleart.addAction(ok)
                        self.present(aleart,animated: true)
                    }
                }
            }.resume()
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
