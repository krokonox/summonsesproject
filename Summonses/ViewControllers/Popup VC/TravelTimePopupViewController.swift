//
//  TravelTimePopupViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 1/3/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class TravelTimePopupViewController: BasePopupViewController {

    @IBOutlet weak var alignCenterYConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var hoursTextField: UITextField!
    @IBOutlet weak var minutesTextField: UITextField!
    
    @IBOutlet weak var optionSegment: SegmentedControl!
    @IBOutlet weak var timeSegment: SegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupView() {
        optionSegment.addTarget(self, action: #selector(checkOptionSegment(segmentControll:)), for: .valueChanged)
        timeSegment.addTarget(self, action: #selector(checkTimeSegment(segmentControll:)), for: .valueChanged)
    }
    
    private func setupUI() {
    }
    
    @objc private func checkOptionSegment(segmentControll: UISegmentedControl) {
        print(segmentControll.selectedSegmentIndex)
    }
    
    @objc private func checkTimeSegment(segmentControll: UISegmentedControl) {
        var hours = ""
        var minuts = ""
        switch segmentControll.selectedSegmentIndex {
        case 0:
            hours = "00"
            minuts = "45"
        case 1:
            hours = "01"
            minuts = "15"
        case 2:
            hours = "02"
            minuts = "30"
        case 3:
            hours = ""
            minuts = ""
        default:
            hours = ""
            minuts = ""
        }
        
        hoursTextField.text = hours
        minutesTextField.text = minuts
    }
    
    override func updateKeyboardHeight(_ height: CGFloat) {
        super.updateKeyboardHeight(height)
        if height != 0.0 {
            alignCenterYConstraint.constant = -(height - self.popupView.bounds.size.height) - 60
        } else {
            alignCenterYConstraint.constant = 0
        }
    }
}

extension TravelTimePopupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
