//
//  BaseViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/24/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class BaseViewController: MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back_button")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupRightBarButtonItem()
    }
    
    func setupRightBarButtonItem() {
        let menuButton = UIBarButtonItem(image:#imageLiteral(resourceName: "menu_icon"), style: .plain, target: self, action: #selector(pushSettingsViewController))
        self.parent?.navigationItem.rightBarButtonItem =  menuButton
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
