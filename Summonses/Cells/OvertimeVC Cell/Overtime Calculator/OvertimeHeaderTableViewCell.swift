//
//  OvertimeHeaderTableViewCell.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 12/29/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class OvertimeHeaderTableViewCell: MainTableViewCell {
  
  @IBOutlet weak var startTimeLabel: UILabel!
  @IBOutlet weak var endTimeLabel: UILabel!
	@IBOutlet weak var actualStartTimeLabel: UILabel!
	@IBOutlet weak var actualEndTimeLabel: UILabel!
  @IBOutlet weak var totalScheduledLabel: UILabel!
  @IBOutlet weak var totalScheduledHelpLabel: UILabel!
  @IBOutlet weak var totalActualLabel: UILabel!
  @IBOutlet weak var totalOverTimeWorkedLabel: UILabel!
  @IBOutlet weak var startTimeTextField: UITextField! //sheduled
  @IBOutlet weak var endTimeTextField: UITextField! //sheduled
  @IBOutlet weak var sTextField: UITextField! //actual
  @IBOutlet weak var eTextField: UITextField! //actual
	
	@IBOutlet weak var backgroundTotal: UIView!
	@IBOutlet weak var backgroundMain: UIView!
	
	@IBOutlet weak var startScheduledTimeStackView: UIStackView!
	@IBOutlet weak var endScheduledTimeStackView: UIStackView!
	@IBOutlet weak var startActualTimeStackView: UIStackView!
	@IBOutlet weak var endActualTimeStackView: UIStackView!
  
  var startScheduledDate: Date? {
    didSet{
      startTimeTextField.text = startScheduledDate?.getStringDate()
      setTotalTime()
    }
  }
  var endScheduledDate: Date? {
    didSet {
      endTimeTextField.text = endScheduledDate?.getStringDate()
      setTotalTime()
    }
  }
  var startActualDate: Date? {
    didSet {
      sTextField.text = startActualDate?.getStringDate()
      setTotalTime()
    }
  }
  var endActualDate: Date? {
    didSet {
      eTextField.text = endActualDate?.getStringDate()
      setTotalTime()
    }
  }
  
  /// Set date, index text field, total owertime worked
  var onDateUpdateForTextF:((Date, TextField)->())?
  var onTotalOvertime: ((Int)->())?
	var onTotalActualTime: ((Int)->())?
  
  override func prepareForReuse() {
    super.prepareForReuse()
		totalActualLabel.text = ""
		totalScheduledLabel.text = ""
		totalOverTimeWorkedLabel.text = ""
  }
	
  override func awakeFromNib() {
    super.awakeFromNib()
    self.selectionStyle = .none
    // Initialization code
	
	let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(setNeedsFocusTextField(recognizer:)))
	let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(setNeedsFocusTextField(recognizer:)))
	let recognizer3 = UITapGestureRecognizer(target: self, action: #selector(setNeedsFocusTextField(recognizer:)))
	let recognizer4 = UITapGestureRecognizer(target: self, action: #selector(setNeedsFocusTextField(recognizer:)))
	recognizer1.delegate = self
	recognizer2.delegate = self
	recognizer3.delegate = self
	recognizer4.delegate = self
	startScheduledTimeStackView.addGestureRecognizer(recognizer1)
	endScheduledTimeStackView.addGestureRecognizer(recognizer2)
	startActualTimeStackView.addGestureRecognizer(recognizer3)
	endActualTimeStackView.addGestureRecognizer(recognizer4)
  }
	
	@objc func setNeedsFocusTextField(recognizer: UITapGestureRecognizer){
		switch recognizer.view?.tag {
		case 1:
			startTimeTextField.becomeFirstResponder()
			break
		case 2:
			endTimeTextField.becomeFirstResponder()
			break
		case 3:
			sTextField.becomeFirstResponder()
			break
		case 4:
			eTextField.becomeFirstResponder()
			break
		default:
			break
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let maskPath = UIBezierPath(roundedRect: backgroundTotal.bounds, byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.bottomRight], cornerRadii: CGSize(width: CGFloat.cornerRadius4, height: CGFloat.cornerRadius4))
		let maskLayer = CAShapeLayer()
		maskLayer.frame = contentView.bounds
		maskLayer.path = maskPath.cgPath
		backgroundTotal.layer.mask = maskLayer
		
		let maskPath1 = UIBezierPath(roundedRect: backgroundMain.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: CGFloat.cornerRadius4, height: CGFloat.cornerRadius4))
		let maskLayer1 = CAShapeLayer()
		maskLayer1.frame = contentView.bounds
		maskLayer1.path = maskPath1.cgPath
		backgroundMain.layer.mask = maskLayer1
		
	}
	
  override func setupViewsCell() {
    startTimeTextField.delegate = self
    endTimeTextField.delegate = self
    sTextField.delegate = self
    eTextField.delegate = self
  }
  
  func switchToRDO(isOn: Bool) {
    if isOn {
      startTimeLabel.text = "R"
      endTimeLabel.text = "D"
      totalScheduledHelpLabel.text = "O"
			startTimeTextField.isEnabled = !isOn
			endTimeTextField.isEnabled = !isOn
			startTimeTextField.text = ""
			endTimeTextField.text = ""
			totalScheduledLabel.text = ""
			totalOverTimeWorkedLabel.text = totalActualLabel.text
			startScheduledDate = nil
			endScheduledDate = nil
    } else {
      startTimeLabel.text = "START TIME"
      endTimeLabel.text = "END TIME"
      totalScheduledHelpLabel.text = "TOTAL"
			startTimeTextField.isEnabled = !isOn
			endTimeTextField.isEnabled = !isOn
    }
  }
  
  private func setTotalTime() {
    var st: (Int)?
    var at: (Int)?
    
    if let startDate = self.startScheduledDate, let endDate = self.endScheduledDate {
      let minute = getDiffMinutes(startDate: startDate, endDate: endDate)
      self.totalScheduledLabel.text = minute.getTimeFromMinutes()
      st = (minute)
    }
    
    if let startDate = self.startActualDate, let endDate = self.endActualDate {
      let minute = getDiffMinutes(startDate: startDate, endDate: endDate)
      self.totalActualLabel.text = minute.getTimeFromMinutes()
			self.onTotalActualTime?(minute)
      at = (minute)
    }
    
    if let s = st, let a = at {
      setTotalOvertimeWirked(scheduledMinutes: s, actualMinutes: a)
    }
    
  }
	
  private func getDiffMinutes(startDate: Date, endDate: Date) -> Int {
		let compForStartDate = Calendar.current.dateComponents([.second], from: startDate)
		let sDate = startDate.addingTimeInterval(TimeInterval(-compForStartDate.second!))
		let compForEndDate = Calendar.current.dateComponents([.second], from: endDate)
		let eDate = endDate.addingTimeInterval(TimeInterval(-compForEndDate.second!))
    let diffInDays = Calendar.current.dateComponents([.minute], from: sDate, to: eDate)
    return diffInDays.minute!
  }
  
  private func setTotalOvertimeWirked(scheduledMinutes: (Int), actualMinutes: (Int)){
    let totalMinutes = actualMinutes - scheduledMinutes
    self.totalOverTimeWorkedLabel.text = totalMinutes.getTimeFromMinutes()
    onTotalOvertime?(totalMinutes)
  }
  
  enum TextField: Int {
    case startScheduledDate = 1
    case endScheduledDate
    case startActualDate
    case endActualDate
  }
}

extension OvertimeHeaderTableViewCell: UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		
		if textField == self.startTimeTextField {
			startTimeLabel.textColor = .white
			if endScheduledDate != nil {
				enableDatePicker(textField: textField, date: endScheduledDate!, isStartDate: false, actualDate: startScheduledDate)
			} else {
//				enableDatePicker(textField: textField)
				enableDatePicker(textField: textField, date: self.startScheduledDate)
			}
		}
		if textField == self.endTimeTextField {
			endTimeLabel.textColor = .white
			if startScheduledDate != nil {
				enableDatePicker(textField: textField, date: startScheduledDate!, isStartDate: true, actualDate: endScheduledDate)
			} else {
//				enableDatePicker(textField: textField)
				enableDatePicker(textField: textField, date: self.endScheduledDate)
			}
		}
		if textField == self.sTextField {
			actualStartTimeLabel.textColor = .white
			if endActualDate != nil {
				enableDatePicker(textField: textField, date: endActualDate!, isStartDate: false, actualDate: startActualDate)
			} else {
//				enableDatePicker(textField: textField)
				enableDatePicker(textField: textField, date: self.startActualDate)
			}
		}
		if textField == self.eTextField {
			actualEndTimeLabel.textColor = .white
			if startActualDate != nil {
				enableDatePicker(textField: textField, date: startActualDate!, isStartDate: true, actualDate: endActualDate)
			} else {
//				enableDatePicker(textField: textField)
				enableDatePicker(textField: textField, date: self.endActualDate)
			}
		}
		
    onDateValueUpdated = { [weak self] (dateAndTime) in
      if textField == self?.startTimeTextField {
        self?.startScheduledDate = dateAndTime
        self?.onDateUpdateForTextF?(dateAndTime, .startScheduledDate)
      }
      if textField == self?.endTimeTextField {
        self?.endScheduledDate = dateAndTime
        self?.onDateUpdateForTextF?(dateAndTime, .endScheduledDate)
      }
      if textField == self?.sTextField{
        self?.startActualDate = dateAndTime
        self?.onDateUpdateForTextF?(dateAndTime, .startActualDate)
      }
      if textField == self?.eTextField {
        self?.endActualDate = dateAndTime
        self?.onDateUpdateForTextF?(dateAndTime, .endActualDate)
      }
    }
    return true
  }
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField == self.startTimeTextField {
			startTimeLabel.textColor = .customBlue2
		}
		if textField == self.endTimeTextField {
			endTimeLabel.textColor = .customBlue2
		}
		if textField == self.sTextField {
			actualStartTimeLabel.textColor = .customBlue2
		}
		if textField == self.eTextField {
			actualEndTimeLabel.textColor = .customBlue2
		}
	}
}

