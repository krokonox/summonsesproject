//
//  DescriptionOffenseViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class DescriptionOffenseViewController: UIViewController {

    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var lawLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var descriptionTextView:UITextView!
    
    @IBOutlet weak var codeLabel: UILabel!
    var offence : OffenseModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.topItem?.title = ""
//        navigationItem.title = "FAIL TO PRODUCE REGISTRATION CERTIFICATE"
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        lawLabel.text =         "LAW: \(offence.law)"
        noteLabel.text =        "NOTE: \(offence.number)"
        classNameLabel.text =   "ClASS: \(offence.type)"
        priceLabel.text =       "PRICE: \(offence.price)"
        codeLabel.text =        "CODE: \(offence.code)"
        descriptionTextView.text = offence.descriptionOffense + ("\n \n")
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descriptionTextView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
