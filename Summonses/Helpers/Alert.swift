//
//  Alert.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 12/27/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class Alert: UIAlertController {
  
  fileprivate var alertWindow : UIWindow?
  
  func show() {
    OperationQueue.main.addOperation {
      let window = UIWindow()
      self.alertWindow = window
      window.rootViewController = UIViewController()
      //            window.tintColor = AppDelegate.current.window?.tintColor
      
      let topWindow = UIApplication.shared.windows.last
      window.windowLevel = (topWindow?.windowLevel)! + 1.0
      
      window.backgroundColor = UIColor.clear
      window.rootViewController?.view.backgroundColor = UIColor.clear
      window.makeKeyAndVisible()
      window.rootViewController?.present(self, animated: true, completion: nil)
      
    }
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    alertWindow?.isHidden = true;
    alertWindow = nil;
  }
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
  
  @objc func textDidChangeInRestorePasswordAlert(sender: Any?) {
    
    if let email = textFields?[0].text, let action = actions.first {
      action.isEnabled = !email.isEmpty
    }
  }
  
  var lastHandler: ((UIAlertAction) -> Swift.Void)? = nil
  
  
  func add(cancel: String, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
    lastHandler = handler
    addAction(UIAlertAction(title: cancel, style: UIAlertActionStyle.cancel, handler: handler))
  }
  
  func add(action: String, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
    lastHandler = handler
    addAction(UIAlertAction(title: action, style: UIAlertActionStyle.default, handler: handler))
  }
  
  static func show(title: String?, subtitle: String?, action: ((UIAlertAction) -> Swift.Void)? = nil) {
    let alert = Alert(title: title, message: subtitle, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Button title"), style: UIAlertActionStyle.cancel, handler: action))
    alert.show()
  }
  
}
