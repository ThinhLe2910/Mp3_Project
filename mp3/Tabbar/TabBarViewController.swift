//
//  TabBarViewController.swift
//  mp3
//
//  Created by Thinh on 29/03/2023.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewOnline = HomeViewController()
        viewOnline.tabBarItem = UITabBarItem(title: "Online", image: UIImage(named: "music"), tag: 0)
        let navviewOnline = UINavigationController(rootViewController: viewOnline)
        let viewAccount = CheckAccountViewController()
        viewAccount.tabBarItem = UITabBarItem(title: "Account", image: UIImage(named: "account-tab"), tag: 1)
        let navviewAccount = UINavigationController(rootViewController: viewAccount)
            self.viewControllers = [navviewOnline, navviewAccount]
    }
    
    
}
