//
//  AddVocationPopupController.swift
//  Summonses
//
//  Created by Smikun Denis on 08.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

enum VocationState {
  case vocationDays
  case IVD
}

class AddVocationPopupController: BasePopupViewController {
  
  //MARK: Variables
  
  var startDate: Date?
  var endDate: Date?
  var popupSelectedState: VocationState = .vocationDays {
    willSet {
      if newValue == .IVD {
        endDate = nil
      }
    }
  }
  
  var vocationDays: VDModel? {
    willSet {
      if let startDate = newValue?.startDate, let endDate = newValue?.endDate {
        self.startDate = startDate
        self.endDate = endDate
        popupSelectedState = .vocationDays
      }
    }
  }
  
  var individualVocationDay: IVDModel? {
    willSet {
      if let date = newValue?.date {
        self.startDate = date
        popupSelectedState = .IVD
      }
    }
  }
  
  var onDateValueUpdated : ((Date)->())?
  
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = Calendar.current.timeZone
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "MM.dd.yy"
    return formatter
  }()
  
  var doneCallback: (()->())?
  
  //MARK: IBOutlet's
  
  @IBOutlet weak var firstTextFieldLabel: UILabel!
  @IBOutlet weak var secondTextFieldLabel: UILabel!
  
  @IBOutlet weak var startDateTextField: TextField!
  @IBOutlet weak var endDateTextField: TextField!
  
  @IBOutlet weak var vocationSegmentControl: SegmentedControl!
  
  @IBOutlet weak var alignCenterYConstraint: NSLayoutConstraint!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    updateStateSegmentControl(state: popupSelectedState)
    updateDisplayTextFields(state: popupSelectedState)
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  private func setupViews() {
    startDateTextField.delegate = self
    endDateTextField.delegate = self
  }
  
  override func doneButton() {
    
    switch popupSelectedState {
      
    case .vocationDays:

      updateBacklightTextField(textField: startDateTextField)
      updateBacklightTextField(textField: endDateTextField)
      
      if let vd = vocationDays {
        vd.startDate = startDate
        vd.endDate = endDate
        DataBaseManager.shared.updateVocationDays(vocationDays: vd)
      } else {
        if let startDate = startDate, let endDate = endDate {
          let vocationDay = VDModel(startDate: startDate, endDate: endDate)
          DataBaseManager.shared.createVocationDays(object: vocationDay)
        }
      }
      
      guard startDateTextField.text?.count != 0, endDateTextField.text?.count != 0 else {return}
      
      //print("c1")
      doneCallback?()
      self.dismiss(animated: true, completion: nil)
      
    case .IVD:
      
      updateBacklightTextField(textField: startDateTextField)

      if let ivd = individualVocationDay {
        ivd.date = startDate
        DataBaseManager.shared.updateIndividualVocationDay(ivd: ivd)
      } else {
        if let date = startDate {
          let individualVocationDay = IVDModel(date: date)
          DataBaseManager.shared.createIndividualVocationDay(ivd: individualVocationDay)
//          print("c2")
//          doneCallback?()
//          self.dismiss(animated: true, completion: nil)
        }
      }
      
      guard startDateTextField.text?.count != 0 else {return}
      //print("c3")
      doneCallback?()
      self.dismiss(animated: true, completion: nil)
      
    }
  }
  
  override func clearButton() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func vocationSegmentControlAction(_ sender: UISegmentedControl) {
    popupSelectedState = sender.selectedSegmentIndex == 0 ? .vocationDays : .IVD
    updateDisplayTextFields(state: popupSelectedState)
  }
  
  private func updateStateSegmentControl(state: VocationState) {
    vocationSegmentControl.selectedSegmentIndex = state == .vocationDays ? 0 : 1
  }
  
  private func updateDisplayTextFields(state: VocationState) {
    
    firstTextFieldLabel.text = state == .vocationDays ? "START" : "DATE"
    
    secondTextFieldLabel.isHidden = state == .vocationDays ? false : true
    endDateTextField.isHidden = state == .vocationDays ? false : true
		
    startDateTextField.text = startDate != nil ? dateFormatter.string(from: startDate!) : ""
    endDateTextField.text = endDate != nil ? dateFormatter.string(from: endDate!) : ""
  }
  
  private func updateBacklightTextField(textField: UITextField) {
    
    if let tf = textField as? PopupTextField {
      if tf == startDateTextField {
        tf.backlightTextField(tf.text ?? "")
      }
      if tf == endDateTextField {
        tf.backlightTextField(tf.text ?? "")
      }
    }
    
  }
  
  private func showDatePicker(textField: UITextField) {
		
    let picker = UIDatePicker()
    picker.minimumDate = Date().visibleStartDate!
    picker.maximumDate = Date().visibleEndDate!
    picker.datePickerMode = UIDatePickerMode.date
		picker.timeZone = dateFormatter.timeZone
    picker.addTarget(self, action: #selector(onDateDidChange(_:)), for: .valueChanged)
    
    if textField == startDateTextField {
      if let date = startDate {
        picker.setDate(date, animated: true)
      }
      if let lastDate = endDate {
        picker.maximumDate = lastDate
      }
    }
    
    if textField == endDateTextField {
      if let date = endDate {
        picker.setDate(date, animated: true)
      }
      if let firstDate = startDate {
        picker.minimumDate = firstDate
      }
    }
    
    onDateValueUpdated = { [weak self] (dateAndTime) in
      if textField == self?.startDateTextField {
        self?.startDate = dateAndTime
      }
      if textField == self?.endDateTextField {
        self?.endDate = dateAndTime
      }
      textField.text = self?.dateFormatter.string(from: dateAndTime)
      self?.updateBacklightTextField(textField: textField)
    }
    
    textField.inputView = picker
    
  }
  
  @objc private func onDateDidChange(_ sender: UIDatePicker) {
    if let onValueUpdated = onDateValueUpdated {
      onValueUpdated(sender.date)
    }
  }
  
  override func updateKeyboardHeight(_ height: CGFloat) {
    super.updateKeyboardHeight(height)
    
    if height != 0.0 {
        let popViewHeight = (popupView.frame.height - view.frame.height) / 2
        let constant = height + popViewHeight + 50
        alignCenterYConstraint.constant = -constant
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


extension AddVocationPopupController : UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    showDatePicker(textField: textField)
    
    onDateDidChange(textField.inputView as! UIDatePicker)
    return true
  }
  
}
