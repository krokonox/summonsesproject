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
		cashHH.layer.cornerRadius = CGFloat.cornerRadius4
		cashMM.layer.cornerRadius = CGFloat.cornerRadius4
		timeHH.layer.cornerRadius = CGFloat.cornerRadius4
		timeMM.layer.cornerRadius = CGFloat.cornerRadius4
	}
	
	private func updateBacklightTextField(textField: UITextField) {
		
		if let tf = textField as? PopupTextField {
			if tf == cashHH {
				tf.backlightTextField(tf.text ?? "")
			}
			if tf == cashMM {
				tf.backlightTextField(tf.text ?? "")
			}
			if tf == timeHH {
				tf.backlightTextField(tf.text ?? "")
			}
			if tf == timeMM {
				tf.backlightTextField(tf.text ?? "")
			}
		}
		
	}
	
	private func checkTextField() {
		updateBacklightTextField(textField: cashHH)
		updateBacklightTextField(textField: cashMM)
		updateBacklightTextField(textField: timeHH)
		updateBacklightTextField(textField: timeMM)
	}
	
	override func doneButton() {
		
		checkTextField()
		
		if let casHH = Int(cashHH.text ?? ""), let cashMM = Int(cashMM.text ?? ""), let timeHH = Int(timeHH.text ?? ""), let timeMM = Int(timeMM.text ?? "") {
			callBack?(casHH * 60 + cashMM, timeHH * 60 + timeMM)
			self.view.endEditing(true)
			dismiss(animated: true, completion: nil)
		}
	}
	
	override func updateKeyboardHeight(_ height: CGFloat) {
		super.updateKeyboardHeight(height)
		
		if height != 0.0 {
			alignCenterYConstraint.constant = -((height + popupView.frame.size.height / 2 - self.view.frame.size.height / 2) + 50)
		} else {
			alignCenterYConstraint.constant = 0
		}
		
		UIView.animate(withDuration: 1.0) {
			self.view.layoutIfNeeded()
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
}

extension CashAndTimePopupViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return true
	}
	
}
