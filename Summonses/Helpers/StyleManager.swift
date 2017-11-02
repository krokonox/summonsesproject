//
//  StyleManager.swift
//  Summonses
//
//  Created by Artsiom Shmaenkov on 10/25/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

enum AppStyle : Int {
    case white, dark
    
    func description() -> String{
        switch self {
        case .white:
            return "White"
        case .dark:
            return "Dark"
        }
    }
    
    static func count() -> Int {
        return 2;
    }
    
    func backgrounColorForView() -> UIColor {
        switch self {
        case .white:
            return UIColor.white
        case .dark:
            return UIColor.black
        }
    }
    
    func textColorForLabel() -> UIColor {
        switch self {
        case .white:
            return UIColor.black
        case .dark:
            return UIColor.green
        }
    }
    
    func backgroundColorForSectionHeader() -> UIColor {
        switch self {
        case .white:
            return .lightGray
        case .dark:
            return .darkGray
        }
    }
}

class StyleManager: NSObject {
    static func setAppStyle(appStyle:AppStyle) {
        UserDefaults.standard.set(appStyle.rawValue, forKey: "AppStyle")
        UserDefaults.standard.synchronize()
    }
    
    static func getAppStyle() -> AppStyle {
        return AppStyle(rawValue:UserDefaults.standard.integer(forKey: "AppStyle")) ?? .white
    }
    
    static func updateStyleForViews(viewGroup:[UIView]?) {
        if viewGroup != nil {
            let currentStyle = getAppStyle()
            for view in viewGroup! {
                view.backgroundColor = currentStyle.backgrounColorForView()
            }
        }
    }
    
    static func updateStyleForTextField(textGroup: [UITextField]?) {
        if textGroup != nil {
            let currentStyle = getAppStyle()
            for textField in textGroup! {
                textField.textColor = currentStyle.textColorForLabel()
                textField.backgroundColor = currentStyle.backgrounColorForView()
            }
        }
    }
    
    static func updateStyleForLabel(labelGroup:[UILabel]?) {
        if labelGroup != nil {
            let currentStyle = getAppStyle()
            for label in labelGroup! {
                label.textColor = currentStyle.textColorForLabel()
            }
        }
    }
    
    static func updateStyleForTextView(textViewGroup:[UITextView]?) {
        if textViewGroup != nil {
            let currentStyle = getAppStyle()
            for textView in textViewGroup! {
                textView.textColor = currentStyle.textColorForLabel()
                textView.backgroundColor = currentStyle.backgrounColorForView()
            }
        }
    }
    
    static func updateStyleForTableViewCell(tableCell:UITableViewCell?) {
        if let cell = tableCell {
            let currentStyle = getAppStyle()
            cell.tintColor = UIColor.customBlue
            cell.backgroundColor = currentStyle.backgrounColorForView()
        }
    }
    
    static func updateStyleForTableView(tableViewGroup: [UITableView]?) {
        if tableViewGroup != nil {
            let currentStyle = getAppStyle()
            for table in tableViewGroup! {
                table.backgroundColor = currentStyle.backgrounColorForView()
                table.reloadData()
            }
        }
    }
    
    static func updateStyleForCollectionView(collectionViewGroup: [UICollectionView]?) {
        if collectionViewGroup != nil {
            let currentStyle = getAppStyle()
            for collectionView in collectionViewGroup! {
                collectionView.backgroundColor = currentStyle.backgrounColorForView()
            }
        }
    }
    
    static func updateStyleForImageView(imageViewGroup: [UIImageView]?) {
        if imageViewGroup != nil {
            let currentStyle = getAppStyle()
            for imageView in imageViewGroup! {
                imageView.tintColor = currentStyle.textColorForLabel()
            }
        }
    }
}
