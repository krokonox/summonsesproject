//
//  DescriptionOffenseViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class DescriptionOffenseViewController: BaseViewController {

    @IBOutlet weak var noteLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var lawLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var descriptionTextView:UITextView!
    
    @IBOutlet weak var codeLabel: UILabel!
    var offence : OffenseModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let label = UILabel()//(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width - 30, height: 44))
        label.contentMode = UIViewContentMode.scaleAspectFit
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor = .white
        label.text = "FAIL TO PRODUCE REGISTRATION CERTIFICATE"
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 44))
        label.frame = titleView.bounds
        titleView.addSubview(label)
        self.navigationItem.titleView = titleView
        
  
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "FAIL TO PRODUCE REGISTRATION CERTIFICATE"

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
