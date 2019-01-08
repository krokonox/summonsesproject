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
    
    func enableDatePicker(textField: UITextField) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "GMT")
        let picker = UIDatePicker()
        
        picker.timeZone = TimeZone(identifier: "GMT")
        picker.minimumDate = formatter.date(from: "01-01-1901")
        picker.locale = Locale(identifier: "en_GB")
        picker.datePickerMode = UIDatePickerMode.dateAndTime
        picker.addTarget(self, action: #selector(onDateDidChange(_:)), for: .valueChanged)
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
