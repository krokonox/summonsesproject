//
//  BasePopupViewController.swift
//  Summonses
//
//  Created by Smikun Denis on 09.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class BasePopupViewController: BaseViewController {
  
  override var shouldAutorotate: Bool {
    return true
  }
  
  
  
  @IBOutlet weak var popupView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupPopup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    showPopup()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    hidePopup()
  }
  
  func setupPopup() {
    self.popupView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
    self.popupView.alpha = 0.0;
    self.view.backgroundColor = UIColor.popupBackgroundColor
  }
  
  func showPopup() {
    
    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
      self.popupView.transform = CGAffineTransform.identity
      self.popupView.alpha = 1.0
    }, completion: nil)
    
  }
  
  func hidePopup() {
    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
      self.popupView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
      self.popupView.alpha = 0.0;
    }, completion: nil)
    
  }
  
  
}
