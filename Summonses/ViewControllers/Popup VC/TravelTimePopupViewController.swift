//
//  TravelTimePopupViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 1/3/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

enum TimeStageState: Int {
  case oneStage = 0
  case twoStage = 1
  case threeStage = 2
  case customStage = 3
}

enum OptionState {
  case cashState
  case timeState
}

class TravelTimePopupViewController: BasePopupViewController {
  
  @IBOutlet weak var alignCenterYConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var hoursTextField: UITextField!
  @IBOutlet weak var minutesTextField: UITextField!
  
  @IBOutlet weak var optionSegment: SegmentedControl!
  @IBOutlet weak var timeSegment: SegmentedControl!
  
  struct TimeModel {
    var hour: Int
    var minutes: Int
    
    init(hour: Int, minutes: Int) {
      self.hour = hour
      self.minutes = minutes
    }
    
    var totalMinutes: Int {
      get {
        let totalMinutes = (self.hour * 60) + self.minutes
        return totalMinutes
      }
    }
    
    var hourString: String {
      get {
        if self.hour == 0 && self.minutes == 0 { return "" }
        return numberFormatter.string(from: NSNumber(value: self.hour)) ?? ""
      }
    }
    
    var minutesString: String {
      get {
        if self.minutes == 0 { return "" }
        return numberFormatter.string(from: NSNumber(value: self.minutes)) ?? ""
      }
    }
    
    let numberFormatter: NumberFormatter = {
      
      let formatter = NumberFormatter()
      formatter.numberStyle = .decimal
      formatter.locale = Locale.current
      formatter.minimumIntegerDigits = 2
      formatter.maximumIntegerDigits = 2
      
      return formatter
    }()
    
  }
  
  let timeModes: [TimeModel] = [TimeModel(hour: 0, minutes: 45),
                                TimeModel(hour: 1, minutes: 15),
                                TimeModel(hour: 2, minutes: 30),
                                TimeModel(hour: 0, minutes: 0)]
  
  var popupTimeSelectedState: TimeStageState = .oneStage {
    didSet {
      updateDisplayTextFields(state: popupTimeSelectedState)
    }
  }
  
	var callBack: ((_ option:(String), _ time: (Int), _ isDone:(Bool))->())?
  var totalMinutes = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateDisplayTextFields(state: popupTimeSelectedState)
  }
  
  private func setupView() {
    hoursTextField.delegate = self
    minutesTextField.delegate = self
    optionSegment.addTarget(self, action: #selector(checkOptionSegment(segmentControll:)), for: .valueChanged)
    timeSegment.addTarget(self, action: #selector(checkTimeSegment(segmentControll:)), for: .valueChanged)
  }
  
  private func updateDisplayTextFields(state: TimeStageState) {
    
    let selectIndex = state.rawValue
    let currentTimeMode = timeModes[selectIndex]

    hoursTextField.text = currentTimeMode.hourString
    minutesTextField.text = currentTimeMode.minutesString
    
    totalMinutes = currentTimeMode.totalMinutes
  }
  
  @objc private func checkOptionSegment(segmentControll: UISegmentedControl) {
    print(segmentControll.selectedSegmentIndex)
  }
  
  @objc private func checkTimeSegment(segmentControll: UISegmentedControl) {
    switch segmentControll.selectedSegmentIndex {
    case 0:
      popupTimeSelectedState = .oneStage
    case 1:
      popupTimeSelectedState = .twoStage
    case 2:
      popupTimeSelectedState = .threeStage
    default:
      popupTimeSelectedState = .customStage
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
  
  override func clearButton() {
    super.clearButton()
		callBack?("", 0, false)
    dismiss(animated: true, completion: nil)
  }
  
  override func doneButton() {
    super.doneButton()
    checkTextField()
		
    if let hours: Int = Int(hoursTextField.text ?? ""), let minutes: Int = Int(minutesTextField.text ?? "") {
      callBack?(self.optionSegment.titleForSegment(at: self.optionSegment.selectedSegmentIndex)!, ((hours * 60) + minutes), true)
      dismiss(animated: true, completion: nil)
    }
  }
	
	private func checkTextField() {
		updateBacklightTextField(textField: hoursTextField)
		updateBacklightTextField(textField: minutesTextField)
	}
	
  private func updateBacklightTextField(textField: UITextField) {
    
    if let tf = textField as? PopupTextField {
      if tf == hoursTextField {
        tf.backlightTextField(tf.text ?? "")
      }
      if tf == minutesTextField {
        tf.backlightTextField(tf.text ?? "")
      }
    }
    
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
}

extension TravelTimePopupViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true
  }
  
}
