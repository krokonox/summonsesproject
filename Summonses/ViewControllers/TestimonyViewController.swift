//
//  TestimonyViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 11/1/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class TestimonyViewController:  BaseViewController {


    var offence = OffenseModel()
    var dict = [[String:String]]()
    
    @IBOutlet weak var descriprionLabel: UILabel!
    @IBOutlet weak var descView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    self.automaticallyAdjustsScrollViewInsets = false
        title = "TESTIMONY"
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "iconShare"), for: .normal)
        button.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        button.addTarget(self, action: #selector(self.shareOffense), for: .touchUpInside)
        if dict.count == 0 {
            self.descriprionLabel.text = offence.testimony
        } else {
            self.descriprionLabel.text = replacingOffence()
        }
        // Do any additional setup after loading the view.
    }
    
    func replacingOffence() -> String {
        var descriptionOffence = offence.testimony
        for tmp in dict {
            guard let value = tmp["value"],let title = tmp["title"], value != "" else {
                continue
            }
            descriptionOffence = descriptionOffence.replace(target: title, withString: value)
        }
        return descriptionOffence
    }
    
    func shareOffense() {
        let activityViewController = UIActivityViewController(activityItems: [descriprionLabel.text ?? ""], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
  
    
    

    
    fileprivate func share(_ fileUrl: URL, withName: String = "name") {
        let activityViewController = UIActivityViewController(activityItems: [descriprionLabel.text ?? ""], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)

//        let activityViewController = UIActivityViewController(activityItems: [descriprionLabel.text], applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view
//        activityViewController.excludedActivityTypes = [ .assignToContact]
//        self.present(activityViewController, animated: true, completion: nil)
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
