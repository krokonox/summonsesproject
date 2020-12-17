//
//  CheckBox.swift
//  Summonses
//
//  Created by Stanislav on 5/12/20.
//  Copyright © 2020 neoviso. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "ic_check")! as UIImage
    let uncheckedImage = UIImage(named: "ic_uncheck")! as UIImage

    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(checkedImage.alpha(0.2), for: UIControl.State.normal)
            }
        }
    }

    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }

    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}

extension UIImage {

    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
