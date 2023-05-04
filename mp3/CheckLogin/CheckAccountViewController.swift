//
//  CheckViewController.swift
//  mp3
//
//  Created by Thinh on 02/04/2023.
//

import UIKit

class CheckAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLogin()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
    }
    
    func checkLogin() {
        if let _ = UserDefaults.standard.string(forKey: "token") {
            self.navigationController?.pushViewController(DashboardViewController(), animated: false)
        } else {
            self.navigationController?.pushViewController(LoginViewController(), animated: false)
        }
    }

}
