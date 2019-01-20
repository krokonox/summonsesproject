//
//  Helpers.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox
import SwiftyUserDefaults

extension UIView {
  class func loadFrom(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
    return UINib(
      nibName: nibNamed,
      bundle: bundle
      ).instantiate(withOwner: nil, options: nil)[0] as? UIView
  }
  
  func shakeEasy(duration: TimeInterval = 0.5, xValue: CGFloat = 12, yValue: CGFloat = 0) {
    self.transform = CGAffineTransform(translationX: xValue, y: yValue)
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
      self.transform = CGAffineTransform.identity
    }, completion: nil)

  }
  
  func shakeHard(duration: TimeInterval = 0.5) {
    let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
    
    // Swift 4.2 and above
    //animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
    
    // Swift 4.1 and below
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    animation.duration = duration
    animation.values = [-12.0, 12.0, -12.0, 12.0, -6.0, 6.0, -3.0, 3.0, 0.0]
    self.layer.add(animation, forKey: "shake")
    AudioServicesPlayAlertSound(1521)
  }

  
  @IBInspectable
  var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      //  layer.masksToBounds = newValue > 0
    }
  }
  
  @IBInspectable
  var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  @IBInspectable
  var borderColor: UIColor? {
    get {
      if let color = layer.borderColor {
        return UIColor(cgColor: color)
      }
      return nil
    }
    set {
      if let color = newValue {
        layer.borderColor = color.cgColor
      } else {
        layer.borderColor = nil
      }
    }
  }
  
  @IBInspectable
  var shadowRadius: CGFloat {
    get {
      return layer.shadowRadius
    }
    set {
      layer.shadowRadius = newValue
    }
  }
  
  @IBInspectable
  var shadowOpacity: Float {
    get {
      return layer.shadowOpacity
    }
    set {
      layer.shadowOpacity = newValue
    }
  }
  
  @IBInspectable
  var shadowOffset: CGSize {
    get {
      return layer.shadowOffset
    }
    set {
      layer.shadowOffset = newValue
    }
  }
  
  @IBInspectable
  var shadowColor: UIColor? {
    get {
      if let color = layer.shadowColor {
        return UIColor(cgColor: color)
      }
      return nil
    }
    set {
      if let color = newValue {
        layer.shadowColor = color.cgColor
      } else {
        layer.shadowColor = nil
      }
    }
  }
}

extension CGFloat {
  static let cornerRadius4: CGFloat = 4
  static let cornerRadius10: CGFloat = 10
}

// MARK: INT
extension Int {
  /// get time from minutes
  ///
  /// - Returns: 00:00
  func getTime() -> String {
    let total = Double(self) / 60.0
    let numberString = String(total)
    let numberComponent = numberString.components(separatedBy :".")
    let integerNumber = Int(numberComponent [0]) ?? 00
    let fractionalNumber = Int(total.truncatingRemainder(dividingBy: 1) * 60)
    
    return String(format: "%02d:%02d", integerNumber, fractionalNumber)
  }
	
	func setEarned() -> String {
		let time: Double = Double(self) / 60.0
		return "$"+String(format: "%.0f", time * 45)
	}
	
}

// MARK: UserDefaults

extension DefaultsKeys {
  static let proPurchaseMade = DefaultsKey<Bool>("proPurchaseMade")
  
}

extension UIColor {
  
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  
  convenience init(netHex:Int) {
    self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
  }
  
  
  static let customBlue = UIColor(netHex: 0x1551A9)
  static let lightBlue = UIColor(netHex: 0xf1f4f8)
  static let customRed = UIColor(netHex : 0xFF2301)
  static let darkBlue = UIColor(netHex : 0x06235b)
  static let darkBlue2 = UIColor(netHex: 0x02112e)
  static let lightGray = UIColor(netHex : 0xb9c2d0)
  static let customBlue1 = UIColor(netHex: 0x1452a9)
  static let bgMainCell = UIColor(netHex: 0xF7F9FC)
  static let daysCurrentMonth = UIColor(netHex: 0xFFFFFF)
  static let popupBackgroundColor = UIColor.black.withAlphaComponent(0.7)
  
}

class TextField: UITextField {
  
  let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, padding)
  }
  
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, padding)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(bounds, padding)
  }
}

extension String {
  func replace(target: String, withString: String) -> String {
    return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
  }
}

extension Array where Element: Hashable {
  var orderedSet: Array {
    return NSOrderedSet(array: self).array as? Array ?? []
  }
}

extension NSObject {
  static var className: String {
    return String(describing: self)
  }
}

extension Notification.Name {
  public static let rdoOvertimeDidChange: Notification.Name = Notification.Name(rawValue: "rdoOvertimeDidChange")
  public static let monthDidChange = NSNotification.Name(rawValue: "monthDidChange")
}

extension Date {
  
  var visibleStartDate: Date? {
    get {
      let firstYear = self.getVisibleYears().first!
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd MM yyyy"
      let date = dateFormatter.date(from: "01 01 \(firstYear)")
      
      return date!
    }
  }
  
  var visibleEndDate: Date? {
    get {
      let lastYear = self.getVisibleYears().last!
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd MM yyyy"
      let date = dateFormatter.date(from: "31 12 \(lastYear)")
      
      return date!
    }
  }
  
  func getVisibleStartDate() -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MM yyyy"
    let firstYear = self.getVisibleYears().first!
    let date = dateFormatter.date(from: "01 01 \(firstYear)")
    return date!
  }
  
  func getVisibleEndDate() -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MM yyyy"
    let lastYear = self.getVisibleYears().last!
    let date = dateFormatter.date(from: "31 12 \(lastYear)")
    return date!
  }
  
  func getVisibleYears() -> [String] {
    
    let currentDate = Date()
    let calendar = Calendar.current
    let currentYear = calendar.component(.year, from: currentDate)
    
    let previousYear = currentYear - 1
    let nextYear = currentYear + 1
    
    let yearsArray = ["\(previousYear)", "\(currentYear)", "\(nextYear)"]
    
    return yearsArray
  }
  
  func getmonthNames() -> [String] {
    return ["January", "February", "March", "April", "May",
            "June", "July", "August", "September", "October", "November", "December"]
  }
  
  func getDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = Calendar.current.timeZone
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "dd.MM.yy"
    return dateFormatter.string(from: self)
  }
  
  func getYear() -> String {
    let calendar = Calendar.current
    let year = calendar.component(.year, from: self)
    return String(year)
  }
  func getMonth() -> String {
    let calendar = Calendar.current
    let month = calendar.component(.month, from: self)
    return String(month)
  }

  
  /// get date by string
  ///
  /// - Returns: Format = "MMM d, HH:mm"
  func getStringDate() -> String {
    let formatter = DateFormatter()
    formatter.timeZone = Calendar.current.timeZone
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "MMM d, HH:mm"
    return formatter.string(from: self)
  }
  
}

extension Calendar {
  
  func dates(byInterval interval: Int, from fromDate: Date, to toDate: Date) -> [Date] {
    var dates: [Date] = []
    var date = fromDate
        
    while date <= toDate {
      dates.append(date)
      guard let newDate = Calendar.current.date(byAdding: .day, value: interval, to: date) else { break }
      date = newDate
    }
        
    return dates
  }
  
}
