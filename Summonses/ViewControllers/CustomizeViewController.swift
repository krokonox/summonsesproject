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
  var offence = OffenseModel()
  var dict = [[String:String]]()
  
  
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
    let all = Array((matchesForRegexInText(regex: regex, text: offence.testimony)))
    
    var newArray = [String]()
    all.forEach {
      if !newArray.contains($0) {
        newArray.append($0)
      }
    }
    
    for str in newArray {
      dict.append(["title": str , "value": ""])
    }
  }
  
  func matchesForRegexInText(regex: String!, text: String!) -> [String] {
    do {
      let regex = try NSRegularExpression(pattern: regex, options: [])
      let nsString = text as NSString
      var results = Array(Set(regex.matches(in: text,
                                            options: [], range: NSMakeRange(0, nsString.length))))
      
      
      results =  results.sorted (by: {$0.range.location < $1.range.location})
      
      
      return results.map { nsString.substring(with: $0.range)}
      // return array
    } catch let error as NSError {
      print("invalid regex: \(error.localizedDescription)")
      return []
    }
    
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
      tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.cgRectValue.height, 0)
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.title = "CUSTOMIZE"
  }
  
  
  @IBAction func onApplyPress(_ sender: Any) {
    if let vc = self.storyboard?.instantiateViewController(withIdentifier:"TestimonyViewController") as? TestimonyViewController {
      vc.offence = offence
      vc.dict = dict
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @objc func hideKeyboard() {
    tableView.endEditing(true)
  }
  
}

extension CustomizeViewController : UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dict.count + 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == dict.count  {
      let c = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.apply.rawValue) as! ApplyTableViewCell
      return c
    }
    let c = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.customize.rawValue) as! CustomizeTableViewCell
    c.onValueChanged = {[unowned self]  (text) in
      self.dict[indexPath.row]["value"] = text
    }
    c.didFieldReturn = {
      let nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
      if let cell = tableView.cellForRow(at: nextIndexPath) as? CustomizeTableViewCell {
        cell.field.becomeFirstResponder()
      }
    }
    c.field.text = dict[indexPath.row]["value"]
    let title = dict[indexPath.row]["title"]?.replacingOccurrences(of: "[\\[\\]]", with: "", options: [.regularExpression])
    let str = NSAttributedString(string: title!, attributes: [NSAttributedStringKey.foregroundColor: StyleManager.getAppStyle().textColorForPlaceHolder()])
    c.field.attributedPlaceholder = str
    c.selectionStyle = .none
    return c
  }
  
}

extension CustomizeViewController {
  
  enum CellIdentifiers: String {
    case customize = "CustomizeCellIdentifier"
    case apply = "ApplyCellIdentifier"
    
  }
  
}
