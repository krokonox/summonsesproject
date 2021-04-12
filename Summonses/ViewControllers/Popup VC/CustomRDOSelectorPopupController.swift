//
//  AddVocationPopupController.swift
//  Summonses
//
//  Created by Smikun Denis on 08.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CustomRDOSelectorPopupController: BasePopupViewController {
    var tabBarHeight: CGFloat!
    var calendarFrame : CGRect!
    
    var calendarCell : CalendarTableViewCell!
    
    @IBOutlet weak var startDateTextField: TextField!
    @IBOutlet weak var daysDateTextField: TextField!
    
    @IBOutlet weak var datePickerView: UIView!
    
    @IBOutlet weak var datePickerTopConstraint: NSLayoutConstraint!
    
    var onSaveButtonPressed : (()->())?
    var onWillAppear: (()->())?
    var onWillDisappear: (()->())?
    
    var displayDaysOptions: DaysDisplayedModel!
    
    var startDate: Date?
    var endDate: Date?
    
    var localTimeShift: String?
    var localStartDay: String?
    var doneButtonView = UIView(frame: CGRect(x: 0.0 , y: UIScreen.main.bounds.height - 30.0, width: UIScreen.main.bounds.width, height: 30.0))
    
    @IBOutlet weak var saveBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var alertViewHeight: NSLayoutConstraint!
    @IBOutlet weak var alertViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var datePickerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    //MARK: Variables
    @IBAction func saveButtonPressed(_ sender: Any) {
        if let onSaveButtonPressed = onSaveButtonPressed {
            onSaveButtonPressed()
        }
        if let onWillDisappear = onWillDisappear {
            onWillDisappear()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
  //MARK: IBOutlet's
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let onWillAppear = onWillAppear {
        onWillAppear()
    }
    
    setupViews()
   
  }
    
   @IBAction func clearButtonPressed(_ sender: Any) {
        SheduleManager.shared.startDayForCustomRDO = ""
        SheduleManager.shared.timeShiftForCustomRDO = ""
        startDateTextField.text = ""
        daysDateTextField.text = ""
        calendarCell.calendarView.reloadData()
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        SheduleManager.shared.startDayForCustomRDO = localStartDay!
        SheduleManager.shared.timeShiftForCustomRDO = localTimeShift!
        if let onWillDisappear = onWillDisappear {
            onWillDisappear()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
  func setupViews() {
    localStartDay = SheduleManager.shared.startDayForCustomRDO
    localTimeShift = SheduleManager.shared.timeShiftForCustomRDO
    
    startDateTextField.delegate = self
    daysDateTextField.delegate = self
    
    let startDate = SheduleManager.shared.startDayForCustomRDO
    
    if startDate != "" {
        startDateTextField.text = startDate
        self.startDate = dateFormatter.date(from: startDate)
    }
    
    let timeShift = SheduleManager.shared.timeShiftForCustomRDO
    
    if timeShift != "" {
        daysDateTextField.text = timeShift
    }
    
    if UIScreen.main.bounds.height <= 568.0 {
        saveBtnHeight.constant *= 0.5
        saveBtnBottomConstraint.constant *= 0.3
        alertViewHeight.constant *= 0.7
        alertViewBottomConstraint.constant *= 0.5
        datePickerViewHeight.constant *= 0.7
        textView.font = UIFont.systemFont(ofSize: 9.0)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
    } else if UIScreen.main.bounds.height >= 812.0 {
        
    } else {
        saveBtnHeight.constant *= 0.8
        saveBtnBottomConstraint.constant *= 0.8
        //alertViewHeight.constant *= 0.8
        //alertViewBottomConstraint.constant *= 0.8
        datePickerViewHeight.constant *= 0.8
        textView.font = UIFont.systemFont(ofSize: 11.5)
    }
    
    if let calendarCell = Bundle.main.loadNibNamed("CalendarTableViewCell", owner: self, options: nil)?.first as? CalendarTableViewCell {
        calendarCell.selectionStyle = .none
        calendarCell.separatorInset.left = 2000
        calendarCell.displayDaysOptions = displayDaysOptions
        calendarCell.backgroundColor = .clear
        
        calendarFrame.size.width += 30
        
        calendarCell.frame = calendarFrame
        calendarCell.customBackgoundColor = .clear
        calendarCell.whiteView.backgroundColor = .clear
        calendarCell.bottomWhiteView.backgroundColor = UIColor.white.withAlphaComponent(0.90)
        
        calendarCell.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        calendarCell.addGestureRecognizer(tapGesture)
        
       popupView.addSubview(calendarCell)
        if #available(iOS 11.0, *){
            datePickerTopConstraint.constant = calendarFrame.origin.y + calendarFrame.height
        } else {
            datePickerTopConstraint.constant = calendarFrame.origin.y + calendarFrame.height - 0.3
        }
        self.calendarCell = calendarCell
    }
    
       setupDoneButtonView()
  }
    
    @objc private func onTap(_ gesture: UIGestureRecognizer) {
      if (gesture.state == .ended) {
        self.view.endEditing(true)
      }
    }
  
    func setupDoneButtonView() {
        doneButtonView.backgroundColor = UIColor.customBlue
        let doneButton = UIButton()
        doneButton.titleLabel?.textColor = .white
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action:#selector(doneButtonClicked(sender:)), for: UIControl.Event.touchUpInside)
        doneButtonView.addSubview(doneButton)

        doneButton.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: doneButton, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: doneButtonView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: doneButton, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: doneButtonView, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: doneButton, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: doneButtonView, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: doneButton, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: doneButtonView, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        doneButtonView.isHidden = true
        popupView.addSubview(doneButtonView)
        
    }

  @objc func doneButtonClicked(sender: UIButton) {
    self.view.endEditing(true)
  }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
    
  var onDateValueUpdated : ((Date)->())?
    
  let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.timeZone = Calendar.current.timeZone
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.dateFormat = "MM.dd.yy"
      return formatter
  }()
    
  @objc private func onDateDidChange(_ sender: UIDatePicker) {
      if let onValueUpdated = onDateValueUpdated {
        onValueUpdated(sender.date)
      }
   }
    
  private func updateBacklightTextField(textField: UITextField) {
      
      if let tf = textField as? PopupTextField {
        if tf == startDateTextField {
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
      
    if #available(iOS 13.4, *) {
        picker.preferredDatePickerStyle = .wheels
    }
    
      if textField == startDateTextField {
        if let date = startDate {
          picker.setDate(date, animated: true)
        }
        if let lastDate = endDate {
          picker.maximumDate = lastDate
        }
      }
      
    onDateValueUpdated = { [weak self] (dateAndTime) in
      if textField == self?.startDateTextField {
        self?.startDate = dateAndTime
      }

      let dateToStr = self!.dateFormatter.string(from: dateAndTime)
        
      textField.text = dateToStr
      SheduleManager.shared.startDayForCustomRDO = dateToStr
      self?.calendarCell.calendarView.reloadData()
    }
    
    textField.inputView = picker
  }
    
  @IBAction func daysFieldDidChanged(_ sender: Any) {
      switch daysDateTextField.text!.count {
          case 1,6,11:
              daysDateTextField.text = daysDateTextField.text! + "/"
              break
          case 3,8,13:
              reloadData()
              break
          default:
              break
    }
  }
    
  @IBAction func daysFieldEditingDidEnd(_ sender: Any) {
      switch daysDateTextField.text!.count {
          case 2:
              daysDateTextField.text?.removeLast(2)
              break
          case 7:
              daysDateTextField.text?.removeLast(4)
              break
          case 12:
               daysDateTextField.text?.removeLast(4)
               break
          default:
              break
      }

      reloadData()
  }
    
  override func updateKeyboardHeight(_ height: CGFloat) {
    super.updateKeyboardHeight(height)
    
    if UIScreen.main.bounds.height <= 568.0 {
        if height != 0.0 {
            let popViewHeight = (calendarFrame.height - view.frame.height) / 2
            let constant = height + popViewHeight //+ 20.0
            calendarCell.frame.origin.y = calendarFrame.origin.y - constant
            doneButtonView.frame.origin.y = UIScreen.main.bounds.height - 30.0 - height
            //doneButtonView.isHidden = false
            
        } else {
            calendarCell.frame.origin.y = calendarFrame.origin.y
            doneButtonView.frame.origin.y = UIScreen.main.bounds.height - 30.0
            //doneButtonView.isHidden = true
        }
        
        if #available(iOS 11.0, *){
            datePickerTopConstraint.constant = calendarCell.frame.origin.y + calendarFrame.height
        } else {
            datePickerTopConstraint.constant = calendarCell.frame.origin.y + calendarFrame.height - 0.3
        }
        
        UIView.animate(withDuration: 1.0) {
          self.view.layoutIfNeeded()
        }
    } else {
        if height != 0 {
            doneButtonView.frame.origin.y = UIScreen.main.bounds.height - 30.0 - height
            //doneButtonView.isHidden = false
        } else {
            doneButtonView.frame.origin.y = UIScreen.main.bounds.height - 30.0
            //doneButtonView.isHidden = true
        }
        
        UIView.animate(withDuration: 1.0) {
          self.view.layoutIfNeeded()
        }
    }
  }
    
}

extension CustomRDOSelectorPopupController : UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField == startDateTextField {
        showDatePicker(textField: textField)
        onDateDidChange(textField.inputView as! UIDatePicker)
    }
    return true
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.isFirstResponder && textField == daysDateTextField {
            
            let char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")

            if (isBackSpace == -92) {
                switch daysDateTextField.text!.count {
                    case 2:
                        daysDateTextField.text?.removeLast(2)
                        reloadData()
                        break
                    case 5:
                        daysDateTextField.text?.removeLast(3)
                        reloadData()
                        break
                    case 7,12:
                        daysDateTextField.text?.removeLast(4)
                        reloadData()
                        break
                    default:
                        return true
                }
                return false
            }
            
            if daysDateTextField.text!.count == 13 {
                
                return false
            }
            
            let validString = CharacterSet(charactersIn: "")//"89")

            if (textField.textInputMode?.primaryLanguage == "emoji") || textField.textInputMode?.primaryLanguage == nil {
                return false
            }
            if let range = string.rangeOfCharacter(from: validString)
            {
                //print(range)
                return false
            }
        }
        if daysDateTextField.text!.count == 3
            || daysDateTextField.text!.count == 8 {
            
            daysDateTextField.text = daysDateTextField.text! + ", "
        }
        return true
    }
  
    func reloadData(){
        SheduleManager.shared.timeShiftForCustomRDO = daysDateTextField.text!
        calendarCell.calendarView.reloadData()
    }
    
}

    
//@IBAction func daysFieldDidChanged(_ sender: Any) {
//    let text = daysDateTextField.text!
//    switch text.count {
//        case 1,6:
//          let char = text.last
//          if let k = Int(String(char!)) {
//                daysDateTextField.text = text  + "/" + "\(7 - k)"
//            }
//            break
//        default:
//            break
//    }
//}
//func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//    if textField.isFirstResponder && textField == daysDateTextField {
//
//        let char = string.cString(using: String.Encoding.utf8)!
//        let isBackSpace = strcmp(char, "\\b")
//
//        if (isBackSpace == -92) {
//            switch daysDateTextField.text!.count {
//                case 3:
//                    daysDateTextField.text?.removeLast(3)
//                    break
//                case 8:
//                    daysDateTextField.text?.removeLast(5)
//                    break
//                default:
//                    break
//            }
//            return false
//        }
//
//        if daysDateTextField.text!.count == 8 {
//            return false
//        }
//
//        let validString = CharacterSet(charactersIn: "89")
//
//        if (textField.textInputMode?.primaryLanguage == "emoji") || textField.textInputMode?.primaryLanguage == nil {
//            return false
//        }
//        if let range = string.rangeOfCharacter(from: validString)
//        {
//            print(range)
//            return false
//        }
//    }
//
//    if daysDateTextField.text!.count == 3 {
//        daysDateTextField.text = daysDateTextField.text! + ", "
//    }
//
//    return true
//}
