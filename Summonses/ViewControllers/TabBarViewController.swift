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
        self.delegate = self
        let menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "menu_icon"), style: .plain, target: self, action: #selector(pushSettingsViewController))
        navigationItem.rightBarButtonItem =  menuButton
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func pushSettingsViewController() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsViewControllerId") as? SettingsViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return tabBarController.selectedViewController != viewController
    }
    
}
