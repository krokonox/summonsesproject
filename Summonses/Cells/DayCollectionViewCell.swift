//
//  DayCollectionViewCell.swift
//  Summonses
//
//  Created by Smikun Denis on 27.12.2018.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit
import JTAppleCalendar

enum CellType {
    case currentDay
    case payDay(isSelected: Bool)
    case calcPayDay
    case ivdDay
    case weekendDay
    case vocationDays(cellState: CellState)
    case none
}

class DayCollectionViewCell: JTACDayCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var backgroundDayView: UIView!
    @IBOutlet weak var selectDaysView: VocationDayView!
    @IBOutlet weak var payDayView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    open var preferredRadiusSelectDayView: CGFloat! {
        willSet {
            selectDaysView.preferededCornerRadius = newValue
        }
    }
    
    private let column = (min: 0, max: 6)
    
    var cellType: CellType = .none {
        willSet {
            setCellType(type: newValue)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPayDayView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setCellType(type: .none)
    }
    
    private func setupPayDayView() {
        payDayView.layer.cornerRadius = payDayView.frame.height / 2
    }
    
    func setupConstraint(with value: CGFloat) {
        if value == 0.75 {
            self.heightConstraint.constant = self.bounds.height * 0.7
        } else {
            self.heightConstraint.constant = self.bounds.height * 0.8
        }
        
        self.layoutIfNeeded()
    }
    
    private func setCellType(type: CellType) {
        switch type {
        
        case .currentDay:
            backgroundDayView.isHidden = false
            backgroundDayView.layer.borderWidth = 2.0
            backgroundDayView.layer.borderColor = UIColor.borderBlue.cgColor
        case (let .payDay(isSelected: state)):
            payDayView.isHidden = false
            payDayView.backgroundColor = state ? UIColor.darkBlue : .white
        case .calcPayDay:
            payDayView.isHidden = false
            payDayView.backgroundColor = .white
        case (let .vocationDays(cellState: state)):
            //        backgroundDayView.isHidden = false
            //        backgroundDayView.backgroundColor = UIColor.customBlue1
            //        dayLabel.textColor = .white
            //        payDayView.backgroundColor = .white
            //        var cornerRadius = selectDaysView.preferededCornerRadius
            //
            //
            //        switch state.selectedPosition() {
            //
            //        case .left:
            //
            //            let isActiveRight = state.column() == column.max ? true : false
            //
            //            if #available(iOS 11.0, *) {
            //                selectDaysView.layer.cornerRadius = cornerRadius
            //                if isActiveRight {
            //                    selectDaysView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner,
            //                                                          .layerMinXMaxYCorner, .layerMinXMinYCorner]
            //                } else {
            //                    selectDaysView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            //                }
            //            } else {
            //                selectDaysView.setCornerStyle(style: isActiveRight ? .fullRounded : .leftRounded)
            //            }
            //
            //            selectDaysView.leftPadding.isActive = true
            //            selectDaysView.rightPadding.isActive = isActiveRight
            //
            //        case .middle:
            //
            //            let isActiveLeft = state.column() == column.min ? true : false
            //            let isActiveRight = state.column() == column.max ? true : false
            //
            //            if #available(iOS 11.0, *) {
            //
            //                //var cornerRadius: CGFloat = 10.0
            //                var maskedCorners = CACornerMask()
            //
            //                if !isActiveLeft && isActiveRight {
            //                    maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            //                } else if isActiveLeft && !isActiveRight {
            //                    maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            //                } else {
            //                    cornerRadius = 0
            //                    maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            //                }
            //
            //                selectDaysView.layer.cornerRadius = cornerRadius
            //                selectDaysView.layer.maskedCorners = maskedCorners
            //
            //            } else {
            //                if !isActiveLeft && isActiveRight {
            //                    selectDaysView.setCornerStyle(style: .rightRounded)
            //                } else if isActiveLeft && !isActiveRight {
            //                    selectDaysView.setCornerStyle(style: .leftRounded)
            //                } else {
            //                    selectDaysView.setCornerStyle(style: .none)
            //                }
            //
            //            }
            //
            //            selectDaysView.leftPadding.isActive = isActiveLeft
            //            selectDaysView.rightPadding.isActive = isActiveRight
            //
            //        case .right:
            //
            //            let isActiveLeft = state.column() == column.min ? true : false
            //
            //            if #available(iOS 11.0, *) {
            //                selectDaysView.layer.cornerRadius = cornerRadius
            //
            //                if isActiveLeft {
            //                    selectDaysView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner,
            //                                                          .layerMinXMaxYCorner, .layerMinXMinYCorner]
            //                } else {
            //                    selectDaysView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            //                }
            //
            //            } else {
            //                selectDaysView.setCornerStyle(style: isActiveLeft ? .fullRounded : .rightRounded)
            //            }
            //
            //            selectDaysView.leftPadding.isActive = isActiveLeft
            //            selectDaysView.rightPadding.isActive = true
            //        case .full:
            //            if #available(iOS 11.0, *) {
            //                selectDaysView.layer.cornerRadius = cornerRadius
            //                selectDaysView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            //            } else {
            //                selectDaysView.setCornerStyle(style: .fullRounded)
            //            }
            //
            //            selectDaysView.leftPadding.isActive = true
            //            selectDaysView.rightPadding.isActive = true
            //
            //        case .none:
            //
            //            print("noneeeeeeeeeeeeeeeeeeeeeeeeeeeee")
            //        }
            //
            backgroundDayView.layer.borderColor = UIColor.borderBlue.cgColor
            selectDaysView.isHidden = false
            selectDaysView.backgroundColor = .white
            selectDaysView.cornerRadius = CGFloat.cornerRadius10
            payDayView.backgroundColor = UIColor.darkBlue
            dayLabel.textColor = UIColor.darkBlue
        case .ivdDay:
            
            backgroundDayView.layer.borderColor = UIColor.borderBlue.cgColor
            
            backgroundDayView.isHidden = false
            backgroundDayView.backgroundColor = UIColor.customBlue3//UIColor.customBlue1
            dayLabel.textColor = .white
            payDayView.backgroundColor = .white
        case .weekendDay:
            
            backgroundDayView.layer.borderColor = UIColor.white.cgColor
            
            backgroundDayView.isHidden = false
            backgroundDayView.backgroundColor = UIColor.customBlue1
            dayLabel.textColor = .white
            payDayView.backgroundColor = .white
        case .none:
            // set color views
            dayLabel.textColor = .white
            payDayView.backgroundColor = .white
            backgroundDayView.backgroundColor = .clear
            // set borders
            backgroundDayView.layer.borderWidth = 0
            backgroundDayView.layer.borderColor = nil
            backgroundDayView.layer.cornerRadius = CGFloat.cornerRadius10
            // set hidden views
            backgroundDayView.isHidden = true
            selectDaysView.isHidden = true
            payDayView.isHidden = true
            
        }
    }
}


class VocationDayView: UIView {
    
    @IBOutlet var leftPadding: NSLayoutConstraint!
    @IBOutlet var rightPadding: NSLayoutConstraint!
    
    var preferededCornerRadius: CGFloat = 10.0
    
    enum CornersStyle: Int {
        case fullRounded
        case leftRounded
        case rightRounded
        case none
    }
    
    var roundingCorners: UIRectCorner = [] {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: roundingCorners,
                                    cornerRadii: CGSize(width: preferededCornerRadius, height: preferededCornerRadius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        
        self.layer.mask = maskLayer
    }
    
    func setCornerStyle(style: CornersStyle) {
        switch style {
        
        case .fullRounded:
            roundingCorners = UIRectCorner.allCorners
        case .leftRounded:
            roundingCorners = [UIRectCorner.topLeft, UIRectCorner.bottomLeft]
        case .rightRounded:
            roundingCorners = [UIRectCorner.topRight, UIRectCorner.bottomRight]
        case .none:
            return
        }
    }
    
    
}
