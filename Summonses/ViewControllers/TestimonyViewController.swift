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
    
    @objc func shareOffense() {
        let data = generateToPDF(view: descView)
        if let url = storePDF(data) {
            share(url)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func storePDF(_ data: NSMutableData) -> URL?  {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("attachment.pdf")
        //        data.write(to: fileURL, atomically: true)
        if data.write(to: fileURL, atomically: true) {
            return fileURL
        } else {
            return nil
        }
    }
    
    func generateToPDF(view: UIView) -> NSMutableData {
        let data: NSMutableData = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, view.bounds, nil)
        if let context = UIGraphicsGetCurrentContext() {
            UIGraphicsBeginPDFPage()
            view.layer.render(in: context)
            UIGraphicsEndPDFContext()
        }
        return data
    }
    
    fileprivate func share(_ fileUrl: URL, withName: String = "name") {
        let activityViewController = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ .assignToContact]
        self.present(activityViewController, animated: true, completion: nil)
    }

}
