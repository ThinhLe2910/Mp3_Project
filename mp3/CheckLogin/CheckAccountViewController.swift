//
//  CheckViewController.swift
//  mp3
//
//  Created by Thinh on 02/04/2023.
//

import UIKit

class CheckAccountViewController: UIViewController {
    
    var accountAPI : AccountAPIService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountAPI = AccountApi()
        checkLogin()
        view.backgroundColor = .red
        
        // Do any additional setup after loading the view.
    }
    
    func checkLogin() {
        if let _ = UserDefaults.standard.string(forKey: "token") {
            self.navigationController?.pushViewController(DashboardViewController(accountAPI: accountAPI), animated: false)
        } else {
            self.navigationController?.pushViewController(LoginViewController(accountAPI: accountAPI), animated: false)
        }
    }

}
