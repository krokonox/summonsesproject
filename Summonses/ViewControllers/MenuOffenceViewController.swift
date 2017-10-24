//
//  MenuOffenceViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class MenuOffenceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
   //     navigationItem.title = "SUMMONSES"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
 //       self.navigationController?.navigationBar.topItem?.title = ""
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onOffencePress(_ sender: Any) {
        let button = sender as! UIButton
        let index = button.tag
//        switch index {
//        case 0:
//            let vc = self.storyboard?.instantiateViewController(withIdentifier:"SearchOffenceViewController")
//            self.navigationController?.pushViewController(vc!, animated: true)
//            
//        default:
//            break
//        }
        if let vc = self.storyboard?.instantiateViewController(withIdentifier:"SearchOffenceViewController") as! SearchOffenceViewController! {
                vc.titleNav = (button.titleLabel?.text)!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
     
        
        
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
