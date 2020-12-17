//
//  InAppPurchaseVC.swift
//  Summonses
//
//  Created by Vlad Lavrenkov on 2/7/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyStoreKit

class NewInAppPurchaseVC: UIViewController {

    @IBOutlet weak var tpoLabel: UILabel!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var overtimeLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var iCloudLabel: UILabel!
    @IBOutlet weak var widgetLabel: UILabel!
    @IBOutlet weak var firstItemLeftLabel: UILabel!
    @IBOutlet weak var firstItemRightLabel: UILabel!
    @IBOutlet weak var secondItemLeftLabel: UILabel!
    @IBOutlet weak var secondItemRightLabel: UILabel!
    @IBOutlet weak var thirdItemLeftLabel: UILabel!
    @IBOutlet weak var thirdItemRightLabel: UILabel!
    @IBOutlet weak var freeTrialLabel: UILabel!
    
    @IBOutlet weak var summonsesView: UIView!
    @IBOutlet weak var plusSubscriptionView: UIView!
    @IBOutlet weak var foreverView: UIView!
    
    @IBOutlet weak var summonsesbackgroundView: UIView!
    @IBOutlet weak var plusSubscriptionbackgroundView: UIView!
    @IBOutlet weak var foreverbackgroundView: UIView!
    
    @IBOutlet weak var leftStackView: UIStackView!
    @IBOutlet weak var rightStackView: UIStackView!

    @IBOutlet weak var summonsesPriceLabel: UILabel!
    @IBOutlet weak var subscriptionPriceLabel: UILabel!
    @IBOutlet weak var foreverPriceLabel: UILabel!
    
    @IBOutlet weak var upgradeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var upgradeViewTop: NSLayoutConstraint!
    @IBOutlet weak var upgradeViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var contentStackView: UIStackView!
    
    @IBOutlet weak var freeTrialViewTop: NSLayoutConstraint!
    @IBOutlet weak var freeTrialViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var plusAndForeverUpgradeView: UIView!
    @IBOutlet weak var summonsesUpgradeView: UIView!
    
    @IBOutlet weak var summonsesViewheight: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var cancelAnyTimeLabel: UILabel!
    @IBOutlet weak var cancelAnyTimeLabelTop: NSLayoutConstraint!
    
    @IBOutlet weak var upgradeToPlusTittleViewBottom: NSLayoutConstraint!
    
    let textColor =  UIColor(netHex: 0xcdd3de)
    let crossColor =  UIColor(netHex: 0xfc471e)
    
    var array = [String]()
    
    var typeIAP = PurchaseType.fullSummonses
    
    enum viewType {
        case summonses
        case plusSubscription
        case forever
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLabels()
        addGestures()
        selectView(.plusSubscription)
        
        IAPHandler.shared.callback = { [weak self] () in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                switch self?.typeIAP {
                //                case .fullSummonses?:
                //                    if !Defaults[.proOvertimeCalculator] {
                //                        self?.showErrorAlert()
                //                    } else {
                //                        self?.dismiss(animated: true, completion: nil)
                //                    }
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
        
        print("didload")
        
    }
    
    func selectWhenLoad() {
        switch typeIAP {
        case .fullSummonses:
            selectView(.summonses)
            break
        case .fullAccess:
            selectView(.plusSubscription)
            break
        case .endlessAccess:
            selectView(.forever)
            break
        default:
            //selectView(.plusSubscription)
            break
        }
    }
    
    @objc private func onSummonsesTap(_ gesture: UIGestureRecognizer) {
        if (gesture.state == .ended) {
            selectView(.summonses)
        }
    }
    
    @objc private func onPlusSubscriptionTap(_ gesture: UIGestureRecognizer) {
        if (gesture.state == .ended) {
            selectView(.plusSubscription)
        }
    }
    
    @objc private func onForeverViewTap(_ gesture: UIGestureRecognizer) {
        if (gesture.state == .ended) {
            selectView(.forever)
        }
    }
    
    func setupPrice() {
        self.summonsesPriceLabel.text = SettingsManager.shared.summonsesPrice
        self.subscriptionPriceLabel.text = SettingsManager.shared.subscriptionPrice
        self.foreverPriceLabel.text = SettingsManager.shared.fullPrice
    }
    
    func setupViews() {
        //        summonsesPriceLabel.text =  "\(IAPHandler.shared.getProducts(.fullSummonses)?.price ?? 0)$"
        //        subscriptionPriceLabel.text =  "\(IAPHandler.shared.getProducts(.fullAccess)?.price ?? 0)$"
        //        foreverPriceLabel.text =  "\(IAPHandler.shared.getProducts(.endlessAccess)?.price ?? 0)$"
        
        setupPrice()
        
        cancelAnyTimeLabel.isHidden = true
        
        switch UIScreen.main.bounds.height {
        case 568.0:   //iPhone 5
            upgradeViewHeight.constant = 170
            for constraint in summonsesView.constraints {
                if constraint.constant == 35.0 {
                    constraint.constant = 15.0
                }
                if constraint.constant == -103.5 {
                    constraint.constant = -83.5
                }
            }
            for constraint in plusSubscriptionView.constraints {
                if constraint.constant == 35.0 {
                    constraint.constant = 15.0
                }
                if constraint.constant == -103.5 {
                    constraint.constant = -83.5
                }
            }
            for constraint in foreverView.constraints {
                if constraint.constant == 35.0 {
                    constraint.constant = 15.0
                }
                if constraint.constant == -103.5 {
                    constraint.constant = -83.5
                }
            }
            
            for constraint in plusAndForeverUpgradeView.constraints {
                if constraint.constant == 25.0 {
                    constraint.constant = 5.0
                }
            }
            
            for constraint in summonsesUpgradeView.constraints {
                if constraint.constant == 25.0 {
                    constraint.constant = 5.0
                }
            }
            
            for subview in summonsesView.subviews {
                if let label = subview as? UILabel {
                    label.font = UIFont(name: "SFProText-Bold", size: 19.0)
                }
            }
            firstItemLeftLabel.font = UIFont(name: "SFProText-Medium", size: 11.5)
            firstItemRightLabel.font = UIFont(name: "SFProText-Medium", size: 11.5)
            
            for subview in plusSubscriptionView.subviews {
                if let label = subview as? UILabel {
                    label.font = UIFont(name: "SFProText-Bold", size: 19.0)
                }
            }
            secondItemLeftLabel.font = UIFont(name: "SFProText-Medium", size: 11.5)
            secondItemRightLabel.font = UIFont(name: "SFProText-Medium", size: 11.5)
            
            for subview in foreverView.subviews {
                if let label = subview as? UILabel {
                    label.font = UIFont(name: "SFProText-Bold", size: 19.0)
                }
            }
            thirdItemLeftLabel.font = UIFont(name: "SFProText-Medium", size: 11.5)
            thirdItemRightLabel.font = UIFont(name: "SFProText-Medium", size: 11.5)
            
            summonsesViewheight.constant = 80
            
            upgradeViewHeight.constant = 130
            contentStackView.spacing = 10
            freeTrialViewTop.constant -= 27
            upgradeViewTop.constant -= 25
            upgradeViewBottom.constant -= 25
            upgradeToPlusTittleViewBottom.constant -= 10
            freeTrialViewHeight.constant = 20
            freeTrialLabel.font = UIFont(name: "SFProText-Medium", size: 10.0)
            cancelAnyTimeLabelTop.constant = 8
            cancelAnyTimeLabel.font = UIFont(name: "SFProText-Medium", size: 9.5)
            break
        case 667.0:  //iPhone 8
            upgradeViewHeight.constant = 145
            upgradeViewTop.constant -= 20
            upgradeViewBottom.constant -= 20
            contentStackView.spacing = 10
            freeTrialViewTop.constant -= 7
            cancelAnyTimeLabelTop.constant = 10
            freeTrialViewHeight.constant = 23
            freeTrialLabel.font = UIFont(name: "SFProText-Medium", size: 11.0)
            cancelAnyTimeLabel.font = UIFont(name: "SFProText-Medium", size: 10.5)
            break
        case 736.0:  //iPhone 8 plus
            upgradeViewHeight.constant = 150
            upgradeViewTop.constant -= 20
            cancelAnyTimeLabelTop.constant = 10
            break
        case 812.0:  //iPhone 11 pro
            upgradeViewHeight.constant = 170
            upgradeViewTop.constant -= 20
            cancelAnyTimeLabelTop.constant = 10
            break
        case 896.0:  //iPhone 11
            upgradeViewHeight.constant = 225
            upgradeViewTop.constant += 10
            break
        default:
            upgradeViewHeight.constant = 170
        }
    }
    
    func selectView(_ viewType : viewType) {
        if #available(iOS 11.0, *) {
            self.removeSelection()
            switch viewType {
            case .summonses:
                self.summonsesView.borderColor = UIColor.customRed1
                self.summonsesView.borderWidth = 4.0
                self.summonsesbackgroundView.backgroundColor = UIColor.white
                self.typeIAP = .fullSummonses
                break
            case .plusSubscription:
                self.plusSubscriptionView.borderColor = UIColor.customRed1
                self.plusSubscriptionView.borderWidth = 4.0
                self.plusSubscriptionbackgroundView.backgroundColor = UIColor.white
                self.typeIAP = .fullAccess
                self.cancelAnyTimeLabel.isHidden = false
                break
            case .forever:
                self.foreverView.borderColor = UIColor.customRed1
                self.foreverView.borderWidth = 4.0
                self.foreverbackgroundView.backgroundColor = UIColor.white
                self.typeIAP = .endlessAccess
                self.thirdItemRightLabel.text = "One-time"
                self.thirdItemRightLabel.addCharacterSpacing()
                break
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.summonsesView.borderColor = .clear
                self.summonsesView.borderColor = UIColor.customRed1
                
                self.plusSubscriptionView.borderColor = .clear
                self.plusSubscriptionView.borderColor = UIColor.customRed1
                
                self.foreverView.borderColor = .clear
                self.foreverView.borderColor = UIColor.customRed1
            })
            DispatchQueue.main.async {
                self.removeSelection()
                switch viewType {
                case .summonses:
                    self.summonsesView.borderColor = UIColor.customRed1
                    self.summonsesView.borderWidth = 4.0
                    self.summonsesbackgroundView.backgroundColor = UIColor.white
                    self.typeIAP = .fullSummonses
                    break
                case .plusSubscription:
                    self.plusSubscriptionView.borderColor = UIColor.customRed1
                    self.plusSubscriptionView.borderWidth = 4.0
                    self.plusSubscriptionbackgroundView.backgroundColor = UIColor.white
                    self.typeIAP = .fullAccess
                    self.cancelAnyTimeLabel.isHidden = false
                    break
                case .forever:
                    self.foreverView.borderColor = UIColor.customRed1
                    self.foreverView.borderWidth = 4.0
                    self.foreverbackgroundView.backgroundColor = UIColor.white
                    self.typeIAP = .endlessAccess
                    self.thirdItemRightLabel.text = "One-time"
                    self.thirdItemRightLabel.addCharacterSpacing()
                    break
                }
                self.contentStackView.layoutIfNeeded()
            }
        }
    }
    
    func addGestures() {
        let firstTapGesture = UITapGestureRecognizer(target: self, action: #selector(onSummonsesTap(_:)))
        summonsesView.addGestureRecognizer(firstTapGesture)
        let secondTapGesture = UITapGestureRecognizer(target: self, action: #selector(onPlusSubscriptionTap(_:)))
        plusSubscriptionView.addGestureRecognizer(secondTapGesture)
        let thirdTapGesture = UITapGestureRecognizer(target: self, action: #selector(onForeverViewTap(_:)))
        foreverView.addGestureRecognizer(thirdTapGesture)
        
        summonsesView.layer.cornerRadius = 4.0
        plusSubscriptionView.layer.cornerRadius = 4.0
        foreverView.layer.cornerRadius = 4.0
    }
    
    func removeSelection() {
        self.summonsesView.borderColor = .clear
        self.summonsesView.borderWidth = 0.0
        self.summonsesbackgroundView.backgroundColor = UIColor.bgMainCell
        
        self.plusSubscriptionView.borderColor = .clear
        self.plusSubscriptionView.borderWidth = 0.0
        self.plusSubscriptionbackgroundView.backgroundColor = UIColor.bgMainCell
        
        self.foreverView.borderColor = .clear
        self.foreverView.borderWidth = 0.0
        self.foreverbackgroundView.backgroundColor = UIColor.customRed1
        self.thirdItemRightLabel.text = "Save $ 3.99"
        self.thirdItemRightLabel.addCharacterSpacing()
        self.cancelAnyTimeLabel.isHidden = true
    }
    
    func setupLabels() {
        var str = "✗ Overtime Calculator"
        let textColor =  UIColor(netHex: 0xcdd3de)
        let crossColor =  UIColor(netHex: 0xfc471e)
        
        var crossRange = (str as NSString).range(of: "✗")
        var otherRange = (str as NSString).range(of: "Overtime Calculator")
        
        var attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: str)
        
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: otherRange)
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: crossColor , range: crossRange)
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: otherRange)
        
        overtimeLabel.attributedText = attributeString
        
        //        str = "✗ TPO"
        //
        //        crossRange = (str as NSString).range(of: "✗")
        //        otherRange = (str as NSString).range(of: "TPO")
        //
        //        attributeString = NSMutableAttributedString(string: str)
        //
        //        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: otherRange)
        //        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: crossColor , range: crossRange)
        //        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: otherRange)
        //
        //        tpoLabel.attributedText = attributeString
        //
        //        str = "✗ Reference"
        //
        //        crossRange = (str as NSString).range(of: "✗")
        //        otherRange = (str as NSString).range(of: "Reference")
        //
        //        attributeString = NSMutableAttributedString(string: str)
        //
        //        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: otherRange)
        //        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: crossColor , range: crossRange)
        //        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: otherRange)
        //
        //        referenceLabel.attributedText = attributeString
        
        str = "✗ RDO Calendar"
        
        crossRange = (str as NSString).range(of: "✗")
        otherRange = (str as NSString).range(of: "RDO Calendar")
        
        attributeString = NSMutableAttributedString(string: str)
        
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: otherRange)
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: crossColor , range: crossRange)
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: otherRange)
        
        calendarLabel.attributedText = attributeString
        
        str = "✗ iCloud backup"
        
        crossRange = (str as NSString).range(of: "✗")
        otherRange = (str as NSString).range(of: "iCloud backup")
        
        attributeString = NSMutableAttributedString(string: str)
        
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: otherRange)
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: crossColor , range: crossRange)
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: otherRange)
        
        iCloudLabel.attributedText = attributeString
        
        setupAttributedStringLabel(crossRange: "✗", otherRange: "Widget", label: widgetLabel)
        
        for view in leftStackView.subviews {
            if let label = view as? UILabel {
                label.addCharacterSpacing()
            }
        }
        
        for view in rightStackView.subviews {
            if let label = view as? UILabel {
                label.addCharacterSpacing()
            }
        }
        
        firstItemLeftLabel.addCharacterSpacing()
        firstItemRightLabel.addCharacterSpacing()
        secondItemLeftLabel.addCharacterSpacing()
        secondItemRightLabel.addCharacterSpacing()
        thirdItemLeftLabel.addCharacterSpacing()
        thirdItemRightLabel.addCharacterSpacing()
        freeTrialLabel.addCharacterSpacing()
        cancelAnyTimeLabel.addCharacterSpacing()
    }
    
    
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        //if typeIAP != .fullSummonses { return }
        IAPHandler.shared.upgratePro(typeIAP)
    }
    
    @IBAction func restoreButtonPressed(_ sender: Any) {
        IAPHandler.shared.restorePro()
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
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension NewInAppPurchaseVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {}
}

extension UILabel {
    func addCharacterSpacing(kernValue: Double = 0.5) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}

extension NewInAppPurchaseVC {
    func setupAttributedStringLabel(crossRange: String, otherRange: String, label: UILabel) {
        let fullString = "\(crossRange) \(otherRange)"
        
        let crossRange = (fullString as NSString).range(of: crossRange)
        let otherRange = (fullString as NSString).range(of: otherRange)
        
        let attributeString = NSMutableAttributedString(string: fullString)
        
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: otherRange)
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: crossColor , range: crossRange)
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: otherRange)
        
        label.attributedText = attributeString
    }
}
