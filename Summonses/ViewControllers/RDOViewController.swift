//
//  RDOViewController.swift
//  Summonses
//
//  Created by Pavel Budankov on 8/1/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class RDOViewController: BaseViewController {

    override func awakeFromNib() {
        super.awakeFromNib()
        title = "RDO Calendar"
        self.tabBarItem.title = "RDO"
        self.tabBarItem.image = #imageLiteral(resourceName: "tabbar_rdo")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
