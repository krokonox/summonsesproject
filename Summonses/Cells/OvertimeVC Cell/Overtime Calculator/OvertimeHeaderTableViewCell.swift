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
  @IBOutlet weak var totalScheduledLabel: UILabel!
  @IBOutlet weak var totalScheduledHelpLabel: UILabel!
  @IBOutlet weak var totalActualLabel: UILabel!
  @IBOutlet weak var totalOverTimeWorkedLabel: UILabel!
  @IBOutlet weak var startTimeTextField: UITextField!
  @IBOutlet weak var endTimeTextField: UITextField!
  @IBOutlet weak var sTextField: UITextField!
  @IBOutlet weak var eTextField: UITextField!
	
	@IBOutlet weak var backgroundTotal: UIView!
	@IBOutlet weak var backgroundMain: UIView!
  
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
    } else {
      startTimeLabel.text = "START TIME"
      endTimeLabel.text = "END TIME"
      totalScheduledHelpLabel.text = "TOTAL"
    }
  }
  
  private func setTotalTime() {
    var st: (Int)?
    var at: (Int)?
    
    if let startDate = self.startScheduledDate, let endDate = self.endScheduledDate {
      let minute = setdiffInDays(startDate: startDate, endDate: endDate)
      self.totalScheduledLabel.text = minute.getTime()
      st = (minute)
    }
    
    if let startDate = self.startActualDate, let endDate = self.endActualDate {
      let minute = setdiffInDays(startDate: startDate, endDate: endDate)
      self.totalActualLabel.text = minute.getTime()
			self.onTotalActualTime?(minute)
      at = (minute)
    }
    
    if let s = st, let a = at {
      setTotalOvertimeWirked(scheduledMinutes: s, actualMinutes: a)
    }
    
  }
  
  private func setdiffInDays(startDate: Date, endDate: Date) -> Int {
    let diffInDays = Calendar.current.dateComponents([.minute], from: startDate, to: endDate)
    return diffInDays.minute!
  }
  
  private func setTotalOvertimeWirked(scheduledMinutes: (Int), actualMinutes: (Int)){
    let totalMinutes = actualMinutes - scheduledMinutes
    self.totalOverTimeWorkedLabel.text = totalMinutes.getTime()
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
			if endScheduledDate != nil {
				enableDatePicker(textField: textField, date: endScheduledDate!, isStartDate: false)
			} else {
				enableDatePicker(textField: textField)
			}
		}
		if textField == self.endTimeTextField {
			if startScheduledDate != nil {
				enableDatePicker(textField: textField, date: startScheduledDate!, isStartDate: true)
			} else {
				enableDatePicker(textField: textField)
			}
		}
		if textField == self.sTextField {
			if endActualDate != nil {
				enableDatePicker(textField: textField, date: endActualDate!, isStartDate: false)
			} else {
				enableDatePicker(textField: textField)
			}
		}
		if textField == self.eTextField {
			if startActualDate != nil {
				enableDatePicker(textField: textField, date: startActualDate!, isStartDate: true)
			} else {
				enableDatePicker(textField: textField)
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
}

