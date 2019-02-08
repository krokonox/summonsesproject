//
//  TabBarViewController.swift
//  Summonses
//
//  Created by Pavel Budankov on 8/1/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
	
	var homeVC: MenuOffenceViewController!
//	var tpoVC: SecondViewController!
//	var referenceVC: ActionViewController!
//	var rdoVC: ThirdViewController!
//	var overtimeVC: FourthViewController!
	
  override func viewDidLoad() {
    super.viewDidLoad()
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
		
		if let navVC = viewController as? NavigationViewController {
			for viewVC in navVC.viewControllers {
				if let _ = viewVC as? MenuOffenceViewController {
					
				}
				if let _ = viewVC as? CalendarPageViewController {
					if !IAPHandler.shared.rdoCalendar {
						IAPHandler.shared.showIAPVC(.rdoCalendar) { (vc) in
							if vc != nil {
								self.present(vc!, animated: true, completion: nil)
							}
						}
						return false
					}
				}
				if let _ = viewVC as? OvertimePageViewController {
					if !IAPHandler.shared.otCalculator {
						IAPHandler.shared.showIAPVC(.otCalculator) { (vc) in
							guard let vc = vc else { return }
							self.present(vc, animated: true, completion: nil)
						}
						return false
					}
				}
			}
		}
		
    return tabBarController.selectedViewController != viewController
  }
}
