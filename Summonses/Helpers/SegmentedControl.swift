//
//  SegmentedControl.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 12/27/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class SegmentedControl: UISegmentedControl {
  
  var selectedBackgroundColor: UIColor? {
    didSet {
      removeBorders()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    removeBorders()
  }
  
  func customBackgroundColor() -> UIColor {
    return .clear
  }
  
  func selectedItemBackgroundColor() -> UIColor {
    
    if let color = selectedBackgroundColor {
      return color
    }
    
    return .customBlue1
  }
  
  func dividerColor() -> UIColor {
    return .bgMainCell
  }
  
  func changeTitles() {
    
  }
  
  private func removeBorders() {
    
    setBackgroundImage(imageWithColor(color: customBackgroundColor()), for: .normal, barMetrics: .default)
    setBackgroundImage(imageWithColor(color: selectedItemBackgroundColor()), for: .selected, barMetrics: .default)
    setDividerImage(imageWithColor(color: dividerColor()), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    
    changeTitles()
  }
  
  func setItems(items: [String]) {
    self.removeAllSegments()
    for (index, value) in items.enumerated() {
      self.insertSegment(withTitle: value, at: index, animated: false)
    }
    self.selectedSegmentIndex = items.startIndex
  }
  
  // create a 1x1 image with this color
  private func imageWithColor(color: UIColor) -> UIImage {
    let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor);
    context!.fill(rect);
    let image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image!
  }
  
}
