//
//  TabBarViewController.swift
//  Summonses
//
//  Created by Pavel Budankov on 8/1/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyStoreKit

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
    //IAPHandler.shared.begin()
    // Do any additional setup after loading the view.
//    if !Defaults[.proBaseVersion] {
//        self.selectedIndex = 1
//    }
    NotificationCenter.default.addObserver(self, selector:#selector(reloadView), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
  }
  
  @objc func reloadView() {
    if SettingsManager.shared.needsOpenOvertimeHistory == true
      ||  SettingsManager.shared.needsOpenOvertimeCalculator == true {
        SettingsManager.shared.needsOpenOvertimeCalculator = false
        self.selectedIndex = 4
    }
  }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setupTitle(tabBar.selectedItem)
		
    IAPHandler.shared.tabbarCallback = { [weak self] in
        self!.setupImageInTabBar()
    }
		setupImageInTabBar()

//    if SettingsManager.shared.needsOpenOvertimeHistory == true
//      ||  SettingsManager.shared.needsOpenOvertimeCalculator == true {
//        SettingsManager.shared.needsOpenOvertimeCalculator = false
//        self.selectedIndex = 4
//    }
  }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
  
	private func setupImageInTabBar() {
		if let items = tabBar.items {
			for item in items {
				if item.title == "RDO" {
					if !Defaults[.proRDOCalendar] {
						item.image = UIImage(named: "add_in_app")?.withRenderingMode(.alwaysOriginal)
					} else {
						item.image = UIImage(named: "tabbar_rdo")
					}
				}
				if item.title == "Overtime" {
					if !Defaults[.proOvertimeCalculator] {
							item.image = UIImage(named: "add_in_app")?.withRenderingMode(.alwaysOriginal)
					} else {
							item.image = UIImage(named: "tabbar_overtime")
					}
				}
                if item.title == "TPO" {
                    if !Defaults[.proBaseVersion] {
                            item.image = UIImage(named: "add_in_app")?.withRenderingMode(.alwaysOriginal)
                    } else {
                            item.image = UIImage(named: "tabbar_tpo")
                    }
                }
                if item.title == "Reference" {
                    if !Defaults[.proBaseVersion] {
                            item.image = UIImage(named: "add_in_app")?.withRenderingMode(.alwaysOriginal)
                    } else {
                            item.image = UIImage(named: "tabbar_reference")
                    }
                }
//                if item.title == "Summonses" {
//                    if !Defaults[.proBaseVersion] {
//                            item.image = UIImage(named: "add_in_app")?.withRenderingMode(.alwaysOriginal)
//                    } else {
//                            item.image = UIImage(named: "tabbar_summons")
//                    }
//                }
			}
		}
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
//				if let _ = viewVC as? MenuOffenceViewController {
//                    if !Defaults[.proBaseVersion] {
//                        IAPHandler.shared.showIAPVC(.fullSummonses) { (vc) in
//                            if vc != nil {
//                                self.present(vc!, animated: true, completion: nil)
//                            }
//                        }
//                        return false
//                    }
//				}
                if let _ = viewVC as? ReferenceViewController {
                    if !Defaults[.proBaseVersion] {
                        IAPHandler.shared.showIAPVC(.fullSummonses) { (vc) in
                            if vc != nil {
                                self.present(vc!, animated: true, completion: nil)
                            }
                        }
                        return false
                    }
                }
                if let _ = viewVC as? TPOViewController {
                    if !Defaults[.proBaseVersion] {
                        IAPHandler.shared.showIAPVC(.fullSummonses) { (vc) in
                            if vc != nil {
                                self.present(vc!, animated: true, completion: nil)
                            }
                        }
                        return false
                    }
                }
				if let _ = viewVC as? CalendarPageViewController {
					if !Defaults[.proRDOCalendar] {
						IAPHandler.shared.showIAPVC(.rdoCalendar) { (vc) in
							if vc != nil {
								self.present(vc!, animated: true, completion: nil)
							}
						}
						return false
					}
				}
				if let _ = viewVC as? OvertimePageViewController {
					if !Defaults[.proOvertimeCalculator] {
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
