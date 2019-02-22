//
//  ReferenceViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 8/8/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class ReferenceViewController: BaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var referenceData: [ReferenceModel] = []
  var referenceTableData: [ReferenceModel] = []
  
  let identifier = "TPODetailTableViewCell"
  
  override func awakeFromNib() {
    super.awakeFromNib()
    title = "Reference"
    self.tabBarItem.title = "Reference"
    self.tabBarItem.image = #imageLiteral(resourceName: "tabbar_reference")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupUI()
    registerCells()
  }
  
  private func setupView() {
    referenceData = [
      ReferenceModel(name: "10 Codes", fileName: "10Codes"),
			ReferenceModel(name: "Court Locations", fileName: "CourtLocations"),
			ReferenceModel(name: "Family Offenses", fileName: "FamilyOffenses"),
			ReferenceModel(name: "Miranda Warnings", fileName: "MirandaWarnings"),
			ReferenceModel(name: "Often Committed Offences", fileName: "OftenCommitted"),
      ReferenceModel(name: "Phonetic Alphabet", fileName: "PhoneticAlphabet"),
      ReferenceModel(name: "Tint Laws", fileName: "TintLaws"),
    ]
		referenceTableData = referenceData
  }
  
  private func setupUI() {
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.backgroundColor = UIColor.bgMainCell
    searchBar.delegate = self
    searchBar.placeholder = "Search"
  }
  
  private func registerCells() {
    self.tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
  }
  
  private func refilter() {
    let searchText = (searchBar.text ?? "").lowercased()
    if searchText.count > 0 {
      referenceTableData.removeAll()
      let referenceItems = referenceData.filter({ (ref) -> Bool in
        return ref.name.lowercased().contains(searchText)
      })
      referenceTableData.append(contentsOf: referenceItems)
    } else {
      referenceTableData = referenceData
    }
    
    tableView.reloadData()
  }
}

extension ReferenceViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return referenceTableData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TPODetailTableViewCell
    cell.selectionStyle = .none
    cell.title.text = referenceTableData[indexPath.row].name
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "ReferenceDetailViewController") as? ReferenceDetailViewController else { return }
    detailVC.reference = referenceTableData[indexPath.row]
    detailVC.title = referenceTableData[indexPath.row].name
    detailVC.filename = referenceData[indexPath.row].fileName
    self.navigationController?.pushViewController(detailVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 88
  }
  
}

extension ReferenceViewController: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.navigationController?.setNavigationBarHidden(true, animated: true)
    searchBar.showsCancelButton = true
  }
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    refilter()
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    refilter()
    searchBar.showsCancelButton = false
    self.navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
    searchBar.text = ""
    self.navigationController?.setNavigationBarHidden(false, animated: true)
    searchBar.endEditing(true)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
  }
}
