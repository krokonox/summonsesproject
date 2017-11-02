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
    
    // Variables
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

        self.tableView.separatorStyle = .none
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomizeViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        


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
        if let vc = self.storyboard?.instantiateViewController(withIdentifier:"TestimonyViewController") as! TestimonyViewController! {
            vc.offence = offence
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideKeyboard() {
        tableView.endEditing(true)
    }
    
}
    extension CustomizeViewController : UITableViewDelegate, UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CustomizeItem.count.rawValue
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
    
        
        switch CustomizeItem(rawValue: indexPath.row)! {
        case .count:
            fatalError()

        case .fisrtName, .secondName, .driverNumber, .carColor, .state, .carNumber, .location, .summonsNumber, .birthday:
            let title = self.titleDict[indexPath.row]["title"]
            let c = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.customize.rawValue) as! CustomizeTableViewCell
            c.onValueChanged = {[unowned self]  (text) in
                self.titleDict[indexPath.row]["value"] = text
            }
            c.titleLabel.text = title
            cell = c


//        case .birthday:
//            c.titleLabel.text = title
//            let datePickerView:UIDatePicker = UIDatePicker()
//            datePickerView.datePickerMode = UIDatePickerMode.date
//            c.field.inputView = datePickerView
//            c.onValueChanged = {[unowned self]  (text) in
////                let dateFormatter = DateFormatter()
////                dateFormatter.dateFormat = "dd MMM yyyy"
////                let selectedDate = dateFormatter.string(from: datePickerView.date)
////                self.titleDict[indexPath.row]["value"] = selectedDate
//            }
    

        }
        
        cell.selectionStyle = .none
        return cell
    }
    
}

extension CustomizeViewController {
    
    enum CellIdentifiers: String {
        case customize = "CustomizeCellIdentifier"
    }
    
    enum CustomizeItem: Int {
        case fisrtName, secondName, birthday, driverNumber, carColor, state, carNumber, location, summonsNumber
        case count
    }
    
}
