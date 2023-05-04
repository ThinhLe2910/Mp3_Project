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
    var domainName:String!
    var token:String!
    var browser:AccountInfor!
    override func viewDidLoad() {
        super.viewDidLoad()
        domainName = "http://localhost:3000/"
        getAccount()
    }
    override func viewWillAppear(_ animated: Bool) {
        getAccount()
    }
    func getAccount(){
        token = UserDefaults.standard.string(forKey: "token")!
        let url = URL(string: domainName + "account")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let paramString = "token=" + token
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
            let dataInfo = try? jsonDecoder.decode(Account_Result.self, from: data)
            if dataInfo?.result == 1{
                DispatchQueue.main.async {
                    self.txtName.text = dataInfo?.data.name
                    self.txtUserName.text = dataInfo?.data.username
                    self.txtEmail.text = dataInfo?.data.email
                }
            }
            
        }.resume()
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        let alert = UIAlertController(title: "Message", message: "Do you want to update Your Information", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { action in
            let url = URL(string: self.domainName! + "account/update")
            let name = self.txtName.text!
            let email = self.txtEmail.text!
            let username = self.txtUserName.text!
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            let paramString = "token=" + self.token! + "&name=" + name
            + "&username=" + username + "&email=" + email
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
