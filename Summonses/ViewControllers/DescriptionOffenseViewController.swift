//
//  DescriptionOffenseViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class DescriptionOffenseViewController: BaseSettingsViewController {

    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var lawLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var descriptionTextView:UITextView!
    
    @IBOutlet weak var codeLabel: UILabel!
    var offence : OffenseModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        lawLabel.text =         "LAW: \(offence.law)"
        noteLabel.text =        "NOTE: \(offence.number)"
        classNameLabel.text =   "ClASS: \(offence.type)"
        priceLabel.text =       "PRICE: \(offence.price)"
        codeLabel.text =        "CODE: \(offence.code)"
        descriptionTextView.text = offence.descriptionOffense
        descriptionTextView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        setupUI()
        navigationItem.titleView = UIView(frame: CGRect(origin: .zero, size: navigationController?.navigationBar.frame.size ?? .zero))
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
        label.text = "FAIL TO PRODUCE REGISTRATION CERTIFICATE"
        label.adjustsFontSizeToFitWidth = true
        navigationItem.titleView?.addSubview(label)
    }
}
