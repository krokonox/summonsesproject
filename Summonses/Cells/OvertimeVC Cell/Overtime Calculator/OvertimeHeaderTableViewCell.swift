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
    
    var startScheduledDate: Date?
    var endScheduledDate: Date?
    var startActualDate: Date?
    var endActualDate: Date?
    
    /// Set date, index text field, total owertime worked
    var onDateUpdateForTextF:((Date, TextField)->())?
    var onTotalOvertime: ((String)->())?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //        startTimeLabel.text = ""
        //        endTimeLabel.text = ""
        //        sLabel.text = ""
        //        eLabel.text = ""
        //        totalLabel.text = ""
        //        totalOverTimeWorkedLabel.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
        startTimeTextField.delegate = self
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
            self.totalScheduledLabel.text = setTimeFrom(minutes: minute)
            st = (minute)
        }
        
        if let startDate = self.startActualDate, let endDate = self.endActualDate {
            let minute = setdiffInDays(startDate: startDate, endDate: endDate)
            self.totalActualLabel.text = setTimeFrom(minutes: minute)
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
    
    private func setTimeFrom(minutes: Int) -> String {
        let total = Double(minutes) / 60.0
        let numberString = String(total)
        let numberComponent = numberString.components(separatedBy :".")
        let integerNumber = Int(numberComponent [0]) ?? 00
        let fractionalNumber = Int(total.truncatingRemainder(dividingBy: 1) * 60)
        
        return String(format: "%02d:%02d", integerNumber, fractionalNumber)
    }
    
    private func setTotalOvertimeWirked(scheduledMinutes: (Int), actualMinutes: (Int)){
        let totalMinutes = actualMinutes - scheduledMinutes
        self.totalOverTimeWorkedLabel.text = setTimeFrom(minutes: totalMinutes)
        onTotalOvertime?(setTimeFrom(minutes: totalMinutes))
    }
    
    private func setDateToStartAndEndLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"
        formatter.timeZone = TimeZone(identifier: "GMT")
        return formatter.string(from: date)
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
        enableDatePicker(textField: textField)
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
            
            textField.text = self?.setDateToStartAndEndLabel(date: dateAndTime)
            
            self?.setTotalTime()
        }
        return true
    }
}

