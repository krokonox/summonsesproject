//
//  BaseViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/24/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit
import WidgetKit

class BaseViewController: MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        setupLeftBarButtonItem()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupRightBarButtonItem()
    }
    
    func setupLeftBarButtonItem() {
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back_button")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func setupRightBarButtonItem() {
        let menuButton = UIBarButtonItem(image:#imageLiteral(resourceName: "menu_icon"), style: .plain, target: self, action: #selector(pushSettingsViewController))
        
        if let pageVC = self.parent as? UIPageViewController {
            pageVC.navigationItem.rightBarButtonItem = menuButton
        } else {
            navigationItem.rightBarButtonItem = menuButton
        }
        
    }
    
    func updateKeyboardHeight(_ height : CGFloat) {
    }
    
    @objc private func onKeyboardWillShow(_ ntf: Notification) {
        if let value = ntf.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let rect = value.cgRectValue
            updateKeyboardHeight(rect.height)
        }
    }
    
    @objc private func onKeyboardWillHide(_ ntf: Notification) {
        updateKeyboardHeight(0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func clearButton() {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func doneButton() {
        
    }
    
}

extension BaseViewController {
    @available(iOS 14, *)
    @objc public func reloadWidget() {
        print("widget reload")
       // Compiler error fix. Arm64 - current 64-bit ARM CPU architecture,
       // as used since the iPhone 5S and later (6, 6S, SE and 7),
       // the iPad Air, Air 2 and Pro, with the A7 and later chips.
       #if arch(arm64)
       WidgetCenter.shared.reloadAllTimelines()
       #endif
    }
}
