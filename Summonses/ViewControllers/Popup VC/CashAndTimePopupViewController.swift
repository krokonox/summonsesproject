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
	
	var overtimeTotalWorket: Int = 0
	
	var cash: Int = 0 {
		didSet {
			var remainder = overtimeTotalWorket
			remainder -= cash
			setTime(time: remainder)
		}
	}
	var time: Int = 0 {
		didSet {
			var remainder = overtimeTotalWorket
			remainder -= time
			setCash(remainder: remainder)
		}
	}
	
	private func setTime(time: Int) {
		if time == 0 {
			timeHH.text = "00"
			timeMM.text = "00"
		} else {
			let time = getRemainderTime(remainder: time)
			timeHH.text = String(format: "%02d", time.hh)
			timeMM.text = String(format: "%02d", time.mm)
		}
	}
	
	private func setCash(remainder: Int) {
		if remainder == 0 {
			cashHH.text = "00"
			cashMM.text = "00"
		} else {
			let time = getRemainderTime(remainder: remainder)
			cashHH.text = String(format: "%02d", time.hh)
			cashMM.text = String(format: "%02d", time.mm)
		}
	}
	
	private func getRemainderTime(remainder: Int) -> (hh: Int, mm: Int) {
		let total = Double(remainder) / 60.0
		let numberString = String(total)
		let numberComponent = numberString.components(separatedBy :".")
		let integerNumber = Int(numberComponent [0]) ?? 00
		let rem = Int(total.truncatingRemainder(dividingBy: 1) * 60)
		return (hh: integerNumber, mm: rem)
	}
	
	var callBack: ((_ cash: Int,_ time: Int, _ isDone: Bool)->())?
	
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
	
	override func clearButton() {
		super.clearButton()
		callBack?(0, 0, false)
	}
	
	override func doneButton() {
	
		checkTextField()
		
		if let casHH = Int(cashHH.text ?? ""), let cashMM = Int(cashMM.text ?? ""), let timeHH = Int(timeHH.text ?? ""), let timeMM = Int(timeMM.text ?? "") {
			if casHH < 0 || cashMM < 0 || timeHH < 0 || timeMM < 0 {
				return
			}
			callBack?((casHH * 60) + cashMM, (timeHH * 60) + timeMM, true)
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
	
	private func addZero(textField: UITextField) {
		if textField.text == "" {
			textField.text = "00"
		}
	}
	
}

extension CashAndTimePopupViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return true
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let textF: NSString = (textField.text ?? "") as NSString
		let text = textF.replacingCharacters(in: range, with: string)
		
		if textField == self.cashHH {
			let value = (Int(text) ?? 0) * 60
			let valueCashMM = Int(self.cashMM.text ?? "") ?? 0
			cash = value + valueCashMM
			addZero(textField: self.cashMM)
		}
		
		if textField == self.cashMM {
			let value = (Int(text) ?? 0)
			let valueCashHH = (Int(self.cashHH.text ?? "") ?? 0) * 60
			cash = value + valueCashHH
			addZero(textField: self.cashHH)
		}
		if textField == self.timeHH {
			let value = (Int(text) ?? 0) * 60
			let valueTimeMM = Int(self.timeMM.text ?? "") ?? 0
			time = value + valueTimeMM
			addZero(textField: self.timeMM)
		}
		if textField == self.timeMM {
			let value = (Int(text) ?? 0)
			let valueTimeHH = (Int(self.timeHH.text ?? "") ?? 0) * 60
			time = value + valueTimeHH
			addZero(textField: self.timeHH)
		}
		
		return true
	}
	
}
