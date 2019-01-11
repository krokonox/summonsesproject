//
//  TabBarViewController.swift
//  Summonses
//
//  Created by Pavel Budankov on 8/1/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //    self.tabBar.isTranslucent = false
    //    self.tabBar.barTintColor = .white
    //    self.tabBar.layer.borderWidth = 0.0
    //    self.tabBar.clipsToBounds = true
    
    self.delegate = self
    
    let menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "menu_icon"), style: .plain, target: self, action: #selector(pushSettingsViewController))
    navigationItem.rightBarButtonItem =  menuButton
    navigationItem.backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu_icon"), style: .plain, target: self, action: nil)
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupTitle(tabBar.selectedItem)
  }
  
  
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    setupTitle(item)
  }
  
  
  fileprivate func setupTitle(_ item: UITabBarItem?) {
    let title = item?.title ?? ""
    self.title = title
  }
  
  @objc func pushSettingsViewController() {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}

extension TabBarViewController: UITabBarControllerDelegate {
  
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    return tabBarController.selectedViewController != viewController
  }
  
}
