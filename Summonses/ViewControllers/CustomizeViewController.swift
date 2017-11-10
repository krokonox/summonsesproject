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
    var dict = [[String:String]]()
    var descriptionOffence = "On [DATE], I was working a [TIME] tour. I was assigned to [VEHICLE NUMBER] a marked RMP with emergency lighting. I was assigned to VTL enforcement in uniform. At the beginning of my tour I was assigned a TM100 Tint meter and conducted a series of tests as required by the manufacturer. These tests consisted of the following: Inserting the first test plate, which has a known tint percentage of 78% into the tint meter and receiving the appropriate reading of 78%. I then inserted the second test plate, which has a known tint percentage of 27% into the tint meter and receiving the appropriate reading of 27%. These tests assured me that the battery and internal components of the tint meter were functioning properly, as per manufacturer's specifications and the training I received in [MONTH AND YEAR] in the usage and functions of the TM100 Tint Meter. At approximately [TIME], I was traveling [DIRECTION] on [STREET] at the intersection of [STREET]. [STREET ONE] runs east and west with two lanes in each direction. [STREET TWO] is a one lane road traveling southbound. At this point I observed a [COLOR/MAKE/YEAR] [MUST STATE SEDAN IF WRITING REAR WINDOWS] NY plate 123456 traveling [DESCRIBE DIRECTION AND INTERSECTION]. Based upon my training the windows appeared darker than the legal limit of 70% VLT in New York State. I activated my emergency lights and stopped the motorist approximately one block West of [STREET] on [STREET]. I identified the motorist as [NAME] by [STATE/LICENSE CLASS/LICENSE NUMBER]. I then tested the light transmittance of the driver side front window by inserting the glass portion of the window into the tint meter, and received a reading of 28% Visual light transmittance which is below the legal limit of 70% VLT for said vehicle. The driver did not have any medical exemption sticker or letter and was issued one summons for violation of NYS tint laws. Upon completion, the tint meter was tested by me again using the aforementioned test plates and method and was found to still be in working order, giving back the correct tint percentages."
    
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
        fillingDictanary()
        // Do any additional setup after loading the view.
    }
    
    func fillingDictanary() {
        let regex = "\\[(.*?)\\]"
        let all = Array(Set(matchesForRegexInText(regex: regex, text: descriptionOffence)))
        for i in 0...all.count - 1 {
            dict.append(["title": all[i] , "value": ""])
        }
    }
    
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = Array(Set(regex.matches(in: text,
                                                  options: [], range: NSMakeRange(0, nsString.length))))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }}
    
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
    
    func replaceString() {
        for tmp in dict {
            guard let value = tmp["value"],let title = tmp["title"], value != "" else {
                continue
            }
            descriptionOffence = descriptionOffence.replace(target: title, withString: value)
        }
    }
    
    @IBAction func onApplyPress(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier:"TestimonyViewController") as? TestimonyViewController {
            vc.offence = offence
//            replaceString()
///          vc.descriptionOffence = descriptionOffence
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
            print(text)
            self.titleDict[indexPath.row]["value"] = text
        }
        c.didFieldReturn = {
            let nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if let cell = tableView.cellForRow(at: nextIndexPath) as? CustomizeTableViewCell {
                cell.field.becomeFirstResponder()
            }
        }
        c.field.text = titleDict[indexPath.row]["value"]
        c.field.placeholder = titleDict[indexPath.row]["title"]?.replacingOccurrences(of: "[\\[\\]]", with: "", options: [.regularExpression])
        c.selectionStyle = .none
        return c
    }
    
}

extension CustomizeViewController {
    
    enum CellIdentifiers: String {
        case customize = "CustomizeCellIdentifier"
    }
    
}
