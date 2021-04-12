//
//  UnlockAllFeaturesVC.swift
//  Summonses
//
//  Created by neoviso on 15.02.21.
//  Copyright © 2021 neoviso. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyStoreKit

class UnlockAllFeaturesVC: UIViewController {

    @IBOutlet weak var summonsesLabel: UILabel!
    @IBOutlet weak var tpoLabel: UILabel!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var overtimeLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var iCloudLabel: UILabel!
    @IBOutlet weak var foreverPriceLabel: UILabel!
    
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var limitedTimeOfferView: UIView!
    
//    @IBOutlet weak var foreverView: UIView!
    
    let textColor =  UIColor(netHex: 0xcdd3de)
    let crossColor =  UIColor(hexString: "1452a9").cgColor
    
    var array = [String]()
    
    var typeIAP = PurchaseType.specialOffer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabels()
        
        IAPHandler.shared.callback = { [weak self] () in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                switch self?.typeIAP {
                case .otCalculator?:
                    if !Defaults[.proOvertimeCalculator] {
                        self?.showErrorAlert()
                    } else {
                        self?.dismiss(animated: true, completion: nil)
                    }
                case .rdoCalendar?:
                    if !Defaults[.proRDOCalendar] {
                        self?.showErrorAlert()
                    } else {
                        self?.dismiss(animated: true, completion: nil)
                    }
                default:
                    break
                }
            })
        }
    }
    
    func setupPrice() {
        self.foreverPriceLabel.text = SettingsManager.shared.fullPrice
    }
    
    func setupLabels() {
        //setupPrice()
        oldPriceLabel.diagonalStrikeThrough(color: crossColor)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        IAPHandler.shared.upgratePro(typeIAP)
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    private func showErrorAlert() {
        Alert.show(title: nil, subtitle: "Your purchase(s) couldn't be restored.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension UnlockAllFeaturesVC {
    func setupAttributedStringLabel(label: UILabel) {
        let attributeString = NSMutableAttributedString(string: label.text ?? "")
        
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        
        
        label.attributedText = attributeString
    }
}

