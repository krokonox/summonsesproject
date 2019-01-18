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
  case payDay
  case ivdDay
  case vocationDays(cellState: CellState)
  case none
}

class DayCollectionViewCell: JTAppleCell {
  
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var backgroundDayView: UIView!
  @IBOutlet weak var selectDaysView: VocationDayView!
  @IBOutlet weak var payDayView: UIView!
  
  private let column = (min: 0, max: 6)
  
  var cellType: CellType = .none {
    willSet {
      setCellType(type: newValue)
    }
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupBackgroundDayView()
    setupPayDayView()
  }
  
  
  override func prepareForReuse() {
    super.prepareForReuse()
    contentView.backgroundColor = UIColor.darkBlue
    backgroundDayView.backgroundColor = .clear
    payDayView.isHidden = true
    dayLabel.textColor = UIColor.white
  }
  
  private func setupBackgroundDayView() {
    backgroundDayView.layer.cornerRadius = CGFloat.cornerRadius10
    backgroundDayView.isHidden = true
  }
  
  private func setupPayDayView() {
    payDayView.layer.cornerRadius = payDayView.frame.height / 2
    payDayView.isHidden = true
  }
  
  private func setCellType(type: CellType) {
    switch type {

    case .currentDay:
      backgroundDayView.isHidden = false
      backgroundDayView.backgroundColor = .clear
      backgroundDayView.layer.borderWidth = 1.0
      backgroundDayView.layer.borderColor = UIColor.customBlue1.cgColor
      payDayView.backgroundColor = .white
    case .payDay:
      payDayView.isHidden = false
      payDayView.backgroundColor = UIColor.red
    case .ivdDay:
      backgroundDayView.isHidden = false
      backgroundDayView.backgroundColor = UIColor.customBlue1
    case (let .vocationDays(cellState: state)):
      
      switch state.selectedPosition() {
        
      case .left:
        
        let isActiveRight = state.column() == column.max ? true : false
        
        if #available(iOS 11.0, *) {
          selectDaysView.layer.cornerRadius = CGFloat.cornerRadius10
          
          if isActiveRight {
            selectDaysView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner,
                                                  .layerMinXMaxYCorner, .layerMinXMinYCorner]
          } else {
            selectDaysView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
          }
        } else {
          selectDaysView.setCornerStyle(style: isActiveRight ? .fullRounded : .leftRounded)
        }

        selectDaysView.leftPadding.isActive = true
        selectDaysView.rightPadding.isActive = isActiveRight
        
      case .middle:
        
        let isActiveLeft = state.column() == column.min ? true : false
        let isActiveRight = state.column() == column.max ? true : false
        
        if #available(iOS 11.0, *) {
          
          var cornerRadius: CGFloat = 10.0
          var maskedCorners = CACornerMask()
          
          if !isActiveLeft && isActiveRight {
            maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
          } else if isActiveLeft && !isActiveRight {
            maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
          } else {
            cornerRadius = 0
            maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
          }
          
          selectDaysView.layer.cornerRadius = cornerRadius
          selectDaysView.layer.maskedCorners = maskedCorners
        } else {
          
          if !isActiveLeft && isActiveRight {
            selectDaysView.setCornerStyle(style: .rightRounded)
          } else if isActiveLeft && !isActiveRight {
            selectDaysView.setCornerStyle(style: .leftRounded)
          } else {
            selectDaysView.setCornerStyle(style: .none)
          }
          
        }
        
          selectDaysView.leftPadding.isActive = isActiveLeft
          selectDaysView.rightPadding.isActive = isActiveRight

      case .right:
        
        let isActiveLeft = state.column() == column.min ? true : false
        
        if #available(iOS 11.0, *) {
          selectDaysView.layer.cornerRadius = CGFloat.cornerRadius10
          
          if isActiveLeft {
            selectDaysView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner,
                                                  .layerMinXMaxYCorner, .layerMinXMinYCorner]
          } else {
            selectDaysView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
          }
          
        } else {
          selectDaysView.setCornerStyle(style: isActiveLeft ? .fullRounded : .rightRounded)
        }
        
          selectDaysView.leftPadding.isActive = isActiveLeft
          selectDaysView.rightPadding.isActive = true
      case .full:
        if #available(iOS 11.0, *) {
          selectDaysView.layer.cornerRadius = CGFloat.cornerRadius10
          selectDaysView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        } else {
          selectDaysView.setCornerStyle(style: .fullRounded)
        }
        
          selectDaysView.leftPadding.isActive = true
          selectDaysView.rightPadding.isActive = true

      case .none:
        selectDaysView.layer.cornerRadius = 0
        selectDaysView.isHidden = true
        selectDaysView.leftPadding.isActive = true
        selectDaysView.rightPadding.isActive = true
      }
      
      selectDaysView.backgroundColor = .white
      payDayView.backgroundColor = UIColor.customBlue1
            
    case .none:
      dayLabel.textColor = .white
      payDayView.isHidden = true
      payDayView.backgroundColor = UIColor.white
      payDayView.cornerRadius = payDayView.frame.height / 2
      backgroundDayView.isHidden = true
      backgroundDayView.cornerRadius = CGFloat.cornerRadius10
      selectDaysView.isHidden = false
    }
  }
}


class VocationDayView: UIView {
  
  @IBOutlet var leftPadding: NSLayoutConstraint!
  @IBOutlet var rightPadding: NSLayoutConstraint!
  
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
                                cornerRadii: CGSize(width: 10, height: 10))
    
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
