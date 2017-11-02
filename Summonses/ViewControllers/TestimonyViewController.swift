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
    
    @IBOutlet weak var descriprionLabel: UILabel!
    
    @IBOutlet weak var descView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    self.automaticallyAdjustsScrollViewInsets = false
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "iconShare"), for: .normal)
        button.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        button.addTarget(self, action: #selector(self.shareOffense), for: .touchUpInside)
        
        self.descriprionLabel.text = offence.descriptionOffense
        
        title = "TESTMONY"
        // Do any additional setup after loading the view.
    }
    func shareOffense() {
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
        //        UIActivityViewController
        let activityViewController = UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil)
        //        activityViewController.transitioningDelegate = self
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ .assignToContact]
        self.present(activityViewController, animated: true, completion: nil)
    }

//    @IBAction func onSharePress(_ sender: Any) {
//        //share(<#T##data: NSMutableData##NSMutableData#>)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
