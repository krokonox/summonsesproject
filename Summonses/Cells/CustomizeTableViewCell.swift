//
//  CustomizeTableViewCell.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 11/1/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class CustomizeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var field: UITextField!
    
    var onValueChanged : ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.field.delegate = self        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        field.text = ""
        
    }


}


extension CustomizeTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let onValueChanged = self.onValueChanged {
            onValueChanged(textField.text ?? "")
        }
        
    }
    
}
