//
//  AttributedString.swift
//  Summonses
//
//  Created by Smikun Denis on 29.12.2018.
//  Copyright © 2018 neoviso. All rights reserved.
//

import Foundation
import UIKit



enum FontStyle : Int {
  case regular
  case bold
}

struct AttributedString {
  
  static func getString(text: String, size: CGFloat, color: UIColor, fontStyle: FontStyle) -> NSAttributedString {
    
    
    
    let attributes : [NSAttributedStringKey : Any] = [
      NSAttributedStringKey.font : getFont(styleFont: fontStyle, size: size),
      NSAttributedStringKey.foregroundColor : color]
    
    let attributedString = NSAttributedString(string: text, attributes: attributes)
    
    return attributedString
  }
  
}

func getFont(styleFont: FontStyle, size: CGFloat) -> UIFont {
  switch styleFont {
    
    
  case .regular:
    return UIFont.systemFont(ofSize: size)
  case .bold:
    return UIFont.boldSystemFont(ofSize: size)
  }
}
