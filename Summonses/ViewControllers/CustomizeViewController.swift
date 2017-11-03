//
//  CustomizeViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 11/1/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit



class CustomizeViewController:  BaseViewController  {

    @IBOutlet weak var tableView: UITableView!
    
    var titleDict =            [ ["title":"First Name", "value": ""],
                                 ["title":"Last Name",  "value": ""],
                                 ["title":"Birthday",  "value": ""],
                                 ["title":"Driver's License", "value": ""],
                                 ["title":"Car color", "value": ""],
                                 ["title":"State", "value": ""],
                                 ["title":"Car number", "value": ""],
                                 ["title":"Location of occurrence", "value": ""],
                                 ["title":"Summons number",  "value": ""]]
    var offence = OffenseModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomizeViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        

        // Do any additional setup after loading the view.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
        tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.cgRectValue.height, 0)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
         tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "CUSTOMIZE"
    }
 
    
    @IBAction func onApplyPress(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier:"TestimonyViewController") as? TestimonyViewController {
            vc.offence = offence
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideKeyboard() {
        tableView.endEditing(true)
    }
    
}

extension CustomizeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.customize.rawValue) as! CustomizeTableViewCell
        c.onValueChanged = {[unowned self]  (text) in
            self.titleDict[indexPath.row]["value"] = text
        }
        c.didFieldReturn = {
            let nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if let cell = tableView.cellForRow(at: nextIndexPath) as? CustomizeTableViewCell {
                cell.field.becomeFirstResponder()
            }
        }
        c.field.text = titleDict[indexPath.row]["value"]
        c.field.placeholder = titleDict[indexPath.row]["title"]
        c.selectionStyle = .none
        return c
    }
    
}

extension CustomizeViewController {
    
    enum CellIdentifiers: String {
        case customize = "CustomizeCellIdentifier"
    }
    
}
