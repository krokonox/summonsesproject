//
//  BasePageViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 12/29/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class BasePageViewController: UIPageViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setSettingsNavButton()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupPositionPageControl()
  }
  
  private func setupPositionPageControl() {
    for subView in self.view.subviews {
      if subView is UIScrollView{
        
        /** Раскоменить если нужен скрол на всю область View
         */
        
        //subView.frame = self.view.bounds
      } else if subView is UIPageControl {
        subView.subviews.forEach {
          $0.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
          self.view.bringSubview(toFront: subView)
        }
      }
    }
  }
  
  func addViewController(withIdentifier identifier: String) -> UIViewController {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
  }
  
  private func setSettingsNavButton() {
    let menuButton = UIBarButtonItem(image:#imageLiteral(resourceName: "menu_icon"), style: .plain, target: self, action: #selector(pushSettingsViewController))
    navigationItem.rightBarButtonItem =  menuButton
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
  }
  
  @objc func pushSettingsViewController() {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
}
