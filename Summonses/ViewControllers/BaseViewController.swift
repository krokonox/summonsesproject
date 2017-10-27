//
//  BaseViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/24/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class BaseViewController: MainViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width , height: 50))
        myView.backgroundColor = .customBlue
        self.view.insertSubview(myView, at: 0)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
