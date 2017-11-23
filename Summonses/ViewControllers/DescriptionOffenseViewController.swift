//
//  DescriptionOffenseViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class DescriptionOffenseViewController: BaseSettingsViewController {

    
    @IBOutlet weak var priceLabel:          UILabel!
    @IBOutlet weak var lawLabel:            UILabel!
    @IBOutlet weak var classNameLabel:      UILabel!
    @IBOutlet weak var numberLabel:         UILabel!
    @IBOutlet weak var noteLabel:           UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var actionsView:         UIView!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var codeLabel: UILabel!
    var offence : OffenseModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        lawLabel.text =         "LAW: \(offence.law)"
        numberLabel.text =       offence.number
        noteLabel.text =         offence.note
        classNameLabel.text =   "ClASS: \(offence.type)"
        priceLabel.text =       "PRICE: \(offence.price)"
        codeLabel.text =        "CODE: \(offence.code)"
        descriptionTextView.text = offence.descriptionOffense
        descriptionTextView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        if !offence.testimony.isEmpty {
            actionsView.isHidden = false
            descriptionTextView.text = offence.testimony
        }  else if offence.classType ==  "C" || offence.classType == "OATH" || offence.classType == "B" {
            shareButton.isHidden = false
        }
        
        setupUI()
        navigationItem.titleView = UIView(frame: CGRect(origin: .zero, size: navigationController?.navigationBar.frame.size ?? .zero))
    }
    
    

    @IBAction func onSharePress(_ sender: Any) {
        let subject = "New testimony submission: \(offence.number)"
        let coded = "mailto:\(K.appConfig.supportEmail)?subject=\(subject)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if let url = URL(string: coded!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func onTestmonyPress(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier:"TestimonyViewController") as! TestimonyViewController! {
            vc.offence = offence
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    @IBAction func onCustomizePress(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier:"CustomizeViewController") as! CustomizeViewController! {
            vc.offence = offence
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
    }
    
    
    func setupUI(){
        descriptionTextView.tintColor = .customBlue
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descriptionTextView.setContentOffset(CGPoint.zero, animated: false)
        
        let label = UILabel(frame: CGRect(origin: .zero, size: navigationItem.titleView?.frame.size ?? .zero))
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor = .white
        label.text = offence.title
        label.adjustsFontSizeToFitWidth = true
        navigationItem.titleView?.addSubview(label)
    }
}
