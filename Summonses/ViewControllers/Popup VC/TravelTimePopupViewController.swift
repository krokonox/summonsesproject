//
//  TravelTimePopupViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 1/3/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class TravelTimePopupViewController: BasePopupViewController {
  
  @IBOutlet weak var alignCenterYConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var hoursTextField: UITextField!
  @IBOutlet weak var minutesTextField: UITextField!
  
  @IBOutlet weak var optionSegment: SegmentedControl!
  @IBOutlet weak var timeSegment: SegmentedControl!
  
  var callBack: ((_ option:(String), _ time: (Int))->())?
  var minutes = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  private func setupView() {
    optionSegment.addTarget(self, action: #selector(checkOptionSegment(segmentControll:)), for: .valueChanged)
    timeSegment.addTarget(self, action: #selector(checkTimeSegment(segmentControll:)), for: .valueChanged)
  }
  
  @objc private func checkOptionSegment(segmentControll: UISegmentedControl) {
    print(segmentControll.selectedSegmentIndex)
  }
  
  @objc private func checkTimeSegment(segmentControll: UISegmentedControl) {
    var hours = ""
    var minuts = ""
    switch segmentControll.selectedSegmentIndex {
    case 0:
      hours = "00"
      minuts = "45"
      minutes = 45
    case 1:
      hours = "01"
      minuts = "15"
      minutes = 75
    case 2:
      hours = "02"
      minuts = "30"
      minutes = 150
    case 3:
      hours = ""
      minuts = ""
      minutes = 0
    default:
      hours = ""
      minuts = ""
      minutes = 0
    }
    hoursTextField.text = hours
    minutesTextField.text = minuts
  }
  
  override func updateKeyboardHeight(_ height: CGFloat) {
    super.updateKeyboardHeight(height)
    if height != 0.0 {
      alignCenterYConstraint.constant = -(height - self.popupView.bounds.size.height) - 60
    } else {
      alignCenterYConstraint.constant = 0
    }
  }
  
  override func clearButton() {
    super.clearButton()
    dismiss(animated: true, completion: nil)
  }
  
  override func doneButton() {
    super.doneButton()
    if let hours: Int = Int(hoursTextField.text ?? ""), let minutes: Int = Int(minutesTextField.text ?? "") {
      callBack?(self.optionSegment.titleForSegment(at: self.optionSegment.selectedSegmentIndex)!, (hours * 60) + minutes)
    }
    dismiss(animated: true, completion: nil)
  }
}

extension TravelTimePopupViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true
  }
  
}
