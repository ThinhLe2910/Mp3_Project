//
//  TabBarViewController.swift
//  mp3
//
//  Created by Thinh on 29/03/2023.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var musicApiService : MusicApiService!
      var categoryApiService : CategoryApiService!
      var accountApiService : AccountAPIService!
    var recentApiService : RecentApiService!
      var navviewDashboard:UINavigationController!
      override func viewDidLoad() {
          super.viewDidLoad()
          accountApiService = AccountApi()
          musicApiService = MusicApi()
          categoryApiService = CategoryApi()
          recentApiService = RecentAPI()
          let viewOnline = HomeViewController(musicApi: musicApiService,categoryAPI: categoryApiService, recentAPI: recentApiService)
          viewOnline.tabBarItem = UITabBarItem(title: "Online", image: UIImage(named: "music"), tag: 0)
          let navviewOnline = UINavigationController(rootViewController: viewOnline)
          
          let login = LoginViewController(accountAPI: accountApiService, recentAPI: recentApiService)
          login.tabBarItem = UITabBarItem(title: "Account", image: UIImage(named: "account-tab"), tag: 1)
          
          let dashboard = DashboardViewController(accountAPI: accountApiService, recentApi: recentApiService)
          dashboard.tabBarItem = UITabBarItem(title: "Account", image: UIImage(named: "account-tab"), tag: 1)
          
          if let _ = UserDefaults.standard.string(forKey: "token") {
              navviewDashboard = UINavigationController(rootViewController: dashboard)
          } else {
              navviewDashboard = UINavigationController(rootViewController: login)
          }
          self.viewControllers = [navviewOnline, navviewDashboard]
          
          
      }
    
    
}
