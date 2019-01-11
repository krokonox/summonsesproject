//
//  TPOViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 8/8/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class TPOViewController: BaseViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var tpoData: [TPOModel] = []
  var tpoTableData: [TPOModel] = []
  
  let identifier = "TPODetailTableViewCell"
  
  override func awakeFromNib() {
    super.awakeFromNib()
    title = "TPO"
    self.tabBarItem.title = "TPO"
    self.tabBarItem.image = #imageLiteral(resourceName: "tabbar_tpo")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupView()
    setupUI()
    registerCells()
  }
  
  private func setupView() {
    tpoData = Array(DataBaseManager.shared.realm.objects(TPOModel.self))
    tpoTableData = tpoData
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  private func refilter() {
    let searchText = (searchBar.text ?? "").lowercased()
    if searchText.count > 0 {
      tpoTableData.removeAll()
      let tpoItems = tpoData.filter({ (tpo) -> Bool in
        return tpo.name.lowercased().contains(searchText) || tpo.descriptionTPO.lowercased().contains(searchText)
      })
      tpoTableData.append(contentsOf: tpoItems)
    } else {
      tpoTableData = tpoData
    }
    
    tableView.reloadData()
  }
}

extension TPOViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tpoTableData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TPODetailTableViewCell
    cell.selectionStyle = .none
    cell.title.text = tpoTableData[indexPath.row].name
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "TPODetailViewController") as? TPODetailViewController else { return }
    detailVC.tpo = tpoTableData[indexPath.row]
    self.navigationController?.pushViewController(detailVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 88
  }
  
}

extension TPOViewController: UISearchBarDelegate {
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
