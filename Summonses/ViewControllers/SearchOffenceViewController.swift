//
//  SearchOffenceViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class SearchOffenceViewController: BaseViewController {
    var offenses: [OffenseModel] = []
    var filteredOffenses = [OffenseModel]()
    var CustomizeViewController = "FAVOURITES"
    var classTypeName = ""
    fileprivate var items: [Section] = [.offenseViews]
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        offenses =  Array(DataBaseManager.shared.realm.objects(OffenseModel.self).filter("classType == %@", classTypeName))
        filteredOffenses = offenses
        tableView.alwaysBounceVertical = false
        
        searchBar.delegate = self
        searchBar.placeholder = "Search and Favorites List"
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } 
        definesPresentationContext = true

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        tableView.register(UINib(nibName: "OffenseTableViewCell", bundle: nil), forCellReuseIdentifier: "offenseidentifierCell")
        NotificationCenter.default.addObserver(self, selector: #selector(SearchOffenceViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        tableView.reloadData()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.backgroundColor = UIColor.bgMainCell
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
          tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.cgRectValue.height, 0)
        }
    }
    
//    func updateSearchResults(for searchController: UISearchController) {
//        if searchController.searchBar.text! == "" {
//            filteredOffenses = offenses.filter({ (it)  -> Bool in
//                return it.isFavourite == true
//            })
//            if filteredOffenses.count == 0 {
//                items = [.emptyDataView, .offenseViews]
//            }
//        } else {
//            filteredOffenses = offenses.filter { $0.title.lowercased().contains(searchController.searchBar.text!.lowercased()) || $0.number.lowercased().contains(searchController.searchBar.text!.lowercased()) }
//        }
//        if !searchController.isActive {
//            items = [.offenseViews]
//            filteredOffenses = offenses
//            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
//        }
//        self.tableView.reloadData()
//    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
    }
    
    func searchBarIsEmpty() -> Bool {
        return true
    }
}

extension SearchOffenceViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch items[section] {
        case .emptyDataView:
            return 1
        case .offenseViews:
            return filteredOffenses.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch items[indexPath.section] {
        case .emptyDataView:
            let c = tableView.dequeueReusableCell(withIdentifier: "EmptyDataViewCell", for: indexPath)
            c.selectionStyle = .none
            cell = c
        case .offenseViews:
            let c = tableView.dequeueReusableCell(withIdentifier: "offenseidentifierCell") as! OffenseTableViewCell
            let offense = filteredOffenses[indexPath.row]
            c.configure(with: offense)
            cell = c
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch items[indexPath.section] {
        case .emptyDataView:
            return 66
        case .offenseViews:
            return 88
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard items[indexPath.section] != .emptyDataView else { return }
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: DescriptionOffenseViewController.className) as? DescriptionOffenseViewController {
            vc.offence = filteredOffenses[indexPath.row]
            searchBar.endEditing(true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

    
    private func refilter() {
        let searchText = (searchBar.text ?? "").lowercased()
        filteredOffenses.removeAll()
        if searchText.count > 0 {
            let filteredOffenseItems = offenses.filter({ (offense) -> Bool in
                return offense.title.lowercased().contains(searchText) || offense.number.lowercased().contains(searchText)
            })
            filteredOffenses.append(contentsOf: filteredOffenseItems)
        } else {
            let favOffenses = Array(DataBaseManager.shared.realm.objects(OffenseModel.self).filter("classType == %@ AND isFavourite == true", classTypeName))
            if favOffenses.count != 0 {
                filteredOffenses = favOffenses
            }
        }
        
        tableView.reloadData()
    }
}

extension SearchOffenceViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        refilter()
        searchBar.showsCancelButton = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        refilter()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        searchBar.text = ""
        filteredOffenses = offenses
        tableView.reloadData()
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            filteredOffenses = offenses
            tableView.reloadData()
        }
        searchBar.endEditing(true)
    }
}

extension SearchOffenceViewController {
    
    fileprivate enum Section: Int {
        case emptyDataView, offenseViews
    }
}



