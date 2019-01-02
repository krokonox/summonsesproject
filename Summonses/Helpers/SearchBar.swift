//
//  SearchBar.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 12/27/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class SearchBar: UISearchBar {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let textField = self.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.bgMainCell
        }
        self.setImage(UIImage(named: "ic_search"), for: .search, state: .normal)
        self.layer.borderColor = UIColor.clear.cgColor
        self.barTintColor = .white
        self.backgroundImage = UIImage()
    }
}
