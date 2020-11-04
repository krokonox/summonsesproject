//
//  TabBarViewController.swift
//  Summonses
//
//  Created by Pavel Budankov on 8/1/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit
class SplashViewController: UIViewController {
    

    
  override func viewDidLoad() {
    super.viewDidLoad()
  }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    IAPHandler.shared.splashCallBack = { [weak self] in
        self!.pushTabBarViewController()
    }
  }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
  
  @objc func pushTabBarViewController() {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController {
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}
