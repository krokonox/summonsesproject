//
//  NotesTableViewCell.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 1/2/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class NotesTableViewCell: MainTableViewCell {

    @IBOutlet weak var notesTitleLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        notesTitleLabel.text = ""
        notesLabel.text = ""
    }
    
    func setNotes(title: String, notes: String) {
        notesTitleLabel.text = title
        notesLabel.text = notes
        notesLabel.textColor = .darkBlue
    }
}
