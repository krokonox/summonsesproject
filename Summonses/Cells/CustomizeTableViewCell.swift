//
//  CustomizeTableViewCell.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 11/1/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class CustomizeTableViewCell: MainTableViewCell {

    @IBOutlet weak var field: UITextField!
    
    var onValueChanged:         ((String) -> Void)?
    var didFieldReturn:         (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.field.delegate = self
        field.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        field.text = ""
        
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        onValueChanged?(textField.text ?? "")
    }

}


extension CustomizeTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        textField.resignFirstResponder()
        didFieldReturn?()
        return true
    }
    
}
