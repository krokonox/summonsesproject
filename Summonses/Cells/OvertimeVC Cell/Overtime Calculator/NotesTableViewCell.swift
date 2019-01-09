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
    @IBOutlet weak var notesTextView: UITextView!
    
    var startEdit: (()->())?
    var updateValue: ((String)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        notesTitleLabel.text = "NOTES"
        notesTextView.textColor = .darkBlue
        notesTextView.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        notesTitleLabel.text = ""
//        notesLabel.text = ""
    }
}

extension NotesTableViewCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        startEdit?()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateValue?(textView.text)
    }
    
}
