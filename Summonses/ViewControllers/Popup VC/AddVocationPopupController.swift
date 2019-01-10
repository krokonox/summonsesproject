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
    
    var startDate: Date?
    var endDate: Date?
    var popupSelectedState: VocationState = .vocationDays
    
    var doneCallback: ((_ state: VocationState)->())?
    
    var onDateValueUpdated : ((Date)->())?
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd.MM.YY"
        return formatter
    }()

    @IBOutlet weak var firstTextFieldLabel: UILabel!
    @IBOutlet weak var secondTextFieldLabel: UILabel!
    
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
        
    @IBOutlet weak var alignCenterYConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setupViews() {
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        startDateTextField.layer.cornerRadius = CGFloat.corderRadius5
        endDateTextField.layer.cornerRadius = CGFloat.corderRadius5
        
    }
    
    override func doneButton() {
        doneCallback?(popupSelectedState)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func clearButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func vocationSegmentControlAction(_ sender: UISegmentedControl) {
        
        popupSelectedState = sender.selectedSegmentIndex == 0 ? .vocationDays : .IVD
        
        switch sender.selectedSegmentIndex {
        case 0:
            updateDisplayTextFields(state: .vocationDays)
        case 1:
            updateDisplayTextFields(state: .IVD)
        default:
            break;
        }
        
    }
    
    private func updateDisplayTextFields(state: VocationState) {
        self.firstTextFieldLabel.text = state == .vocationDays ? "START" : "DATE"
        self.secondTextFieldLabel.isHidden = state == .vocationDays ? false : true
        self.endDateTextField.isHidden = state == .vocationDays ? false : true
    }
    
    private func showDatePicker(textField: UITextField) {
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePickerMode.date
        picker.addTarget(self, action: #selector(onDateDidChange(_:)), for: .valueChanged)
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
            alignCenterYConstraint.constant = -(height - self.popupView.bounds.size.height) - 80
        } else {
            alignCenterYConstraint.constant = 0
        }

        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        startDateTextField.endEditing(true)
        endDateTextField.endEditing(true)
    }

}


extension AddVocationPopupController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        showDatePicker(textField: textField)
        
        onDateValueUpdated = { [weak self] (dateAndTime) in
            
            if textField == self?.startDateTextField {
                self?.startDate = dateAndTime
            }
            if textField == self?.endDateTextField {
                self?.endDate = dateAndTime
            }
            
            textField.text = self?.dateFormatter.string(from: dateAndTime)
        }
        return true
    }
    
}
