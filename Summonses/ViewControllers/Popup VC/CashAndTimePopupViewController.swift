//
//  CashAndTimePopupViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 1/3/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class CashAndTimePopupViewController: BasePopupViewController {

    @IBOutlet weak var cashHH: UITextField!
    @IBOutlet weak var cashMM: UITextField!
    @IBOutlet weak var timeHH: UITextField!
    @IBOutlet weak var timeMM: UITextField!
    @IBOutlet weak var alignCenterYConstraint: NSLayoutConstraint!
    
  var callBack: ((_ cash: Int,_ time: Int)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupView()
    }
    
    private func setupView() {
        cashHH.delegate = self
        cashMM.delegate = self
        timeHH.delegate = self
        timeMM.delegate = self
    }
    
    private func setupUI() {
        cashHH.layer.cornerRadius = CGFloat.corderRadius5
        cashMM.layer.cornerRadius = CGFloat.corderRadius5
        timeHH.layer.cornerRadius = CGFloat.corderRadius5
        timeMM.layer.cornerRadius = CGFloat.corderRadius5
    }
    
    override func doneButton() {
      if let casHH = Int(cashHH.text ?? ""), let cashMM = Int(cashMM.text ?? ""), let timeHH = Int(timeHH.text ?? ""), let timeMM = Int(timeMM.text ?? "") {
        callBack?(casHH * 60 + cashMM, timeHH * 60 + timeMM)
        self.view.endEditing(true)
        dismiss(animated: true, completion: nil)
      }
    }
    
    override func updateKeyboardHeight(_ height: CGFloat) {
        super.updateKeyboardHeight(height)
        if height != 0.0 {
            alignCenterYConstraint.constant = -(height - self.popupView.bounds.size.height) - 60
        } else {
            alignCenterYConstraint.constant = 0
        }
    }
}

extension CashAndTimePopupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
