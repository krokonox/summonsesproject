//
//  MainTableViewCell.swift
//  Summonses
//
//  Created by Artsiom Shmaenkov on 10/25/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

enum TableViewCellCornersStyle : Int {
  case fullRounded
  case topRounded
  case bottomRounded
  case none
}

class MainTableViewCell: UITableViewCell {
  
  var roundingCorners: UIRectCorner = [] {
    didSet {
      setNeedsLayout()
    }
  }
  
  @IBOutlet var viewGroup: [UIView]?
  @IBOutlet var labelGroup: [UILabel]?
  @IBOutlet var textFieldGroup: [UITextField]?
  
  var customContentView: UIView?
  
  var onDateValueUpdated : ((Date)->())?
    var onDidPressDoneButton : (()->())?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    updateStyle()
    self.selectionStyle = .none
    NotificationCenter.default.addObserver(self, selector:#selector(self.updateStyle), name: K.Notifications.didChangeAppStyle, object: nil)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    setupViewsCell()
    
    guard let customContentView = customContentView else { return }
    
    let maskPath = UIBezierPath(roundedRect: customContentView.bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: 4, height: 4))
    
    let maskLayer = CAShapeLayer()
    maskLayer.frame = contentView.bounds
    maskLayer.path = maskPath.cgPath
    
    customContentView.layer.mask = maskLayer
    
  }
  
  @objc func updateStyle() {
    StyleManager.updateStyleForLabel(labelGroup:labelGroup)
    StyleManager.updateStyleForTextField(textGroup: textFieldGroup)
    StyleManager.updateStyleForTableViewCell(tableCell:self)
  }
  
  
  func setCornersStyle(style: TableViewCellCornersStyle) {
    
    switch style {
    case .fullRounded:
      roundingCorners = UIRectCorner.allCorners
      break
    case .topRounded:
      roundingCorners = [UIRectCorner.topLeft, UIRectCorner.topRight]
      break
    case .bottomRounded:
      roundingCorners = [UIRectCorner.bottomLeft, UIRectCorner.bottomRight]
      break
    case .none:
      return
    }
    
  }
  
    func enableDatePicker(textField: UITextField, date: Date?) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.timeZone = Calendar.current.timeZone
    formatter.locale = Locale(identifier: "en_US_POSIX")
    let picker = UIDatePicker()
        
    picker.minimumDate = formatter.date(from: "01-01-1901")
        picker.timeZone = formatter.timeZone
    picker.locale = Locale(identifier: "en_GB")
        if SettingsManager.shared.fiveMinuteIncrements {
            picker.minuteInterval = 5
        } else {
            picker.minuteInterval = 1
        }
        if date != nil {
            picker.date = date!
        }
        picker.datePickerMode = UIDatePickerMode.dateAndTime
        picker.addTarget(self, action: #selector(onDateDidChange(_:)), for: .valueChanged)
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: picker.frame.size.width, height: 44))
        toolbar.isTranslucent = false
        toolbar.barTintColor = .darkBlue
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        doneButton.tintColor = .white
        doneButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14.0, weight: .regular)], for: .normal)
        doneButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14.0, weight: .regular)], for: .selected)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, space, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
    textField.inputView = picker
  }
    
    @objc private func doneClicked() {
        onDidPressDoneButton?()
    }
    
    func enableDatePicker(textField: UITextField, date: Date, isStartDate:Bool, actualDate: Date?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let picker = UIDatePicker()
        
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        
        picker.minimumDate = formatter.date(from: "01-01-1901")
        picker.timeZone = formatter.timeZone
        picker.locale = Locale(identifier: "en_GB")
        if isStartDate {
            picker.minimumDate = date
        } else {
            picker.maximumDate = date
        }
        if SettingsManager.shared.fiveMinuteIncrements {
            picker.minuteInterval = 5
        } else {
            picker.minuteInterval = 1
        }
        
        if actualDate != nil {
            picker.date = actualDate!
        }
        picker.datePickerMode = UIDatePickerMode.dateAndTime
        picker.addTarget(self, action: #selector(onDateDidChange(_:)), for: .valueChanged)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: picker.frame.size.width, height: 44))
        toolbar.isTranslucent = false
        toolbar.barTintColor = .darkBlue
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        doneButton.tintColor = .white
        doneButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14.0, weight: .regular)], for: .normal)
        doneButton.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14.0, weight: .regular)], for: .selected)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, space, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
        
        textField.inputView = picker
    }
  
  @objc private func onDateDidChange(_ sender: UIDatePicker) {
    if let onValueUpdated = onDateValueUpdated {
      onValueUpdated(sender.date)
    }
  }
  
  func setupViewsCell() {
    self.contentView.backgroundColor = UIColor.bgMainCell
  }
  
}
