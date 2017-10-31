//
//  SearchOffenceViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class SearchOffenceViewController: BaseSettingsViewController, UISearchResultsUpdating {
    var  offenses: [OffenseModel] = []
    var filteredOffenses = [OffenseModel]()
    var titleNav = "FAVOURITES"
    let searchController = UISearchController(searchResultsController: nil)
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        offenses =  Array(DataBaseManager.shared.realm.objects(OffenseModel.self))
        filteredOffenses = offenses
        
        tableView.alwaysBounceVertical = false

        
        searchController.searchBar.layer.borderWidth = 1
        searchController.searchBar.layer.borderColor = UIColor.customGray.cgColor
        searchController.searchBar.backgroundColor = .customGray
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = .customGray
        searchController.searchBar.tintColor = .customGray
        
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        tableView.register(UINib(nibName: "OffenseTableViewCell", bundle: nil), forCellReuseIdentifier: "offenseidentifierCell")
        tableView.reloadData()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationItem.title = (offenses.first?.type ?? "") + "SUMMONSES"
    }
    
    func updateSearchResults(for searchController: UISearchController) {

        if searchController.searchBar.text! == "" {
            filteredOffenses = offenses
        } else {
        
            filteredOffenses = offenses.filter { $0.tittle.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        if !searchController.isActive {
            
        }
        
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
    }
    
    func searchBarIsEmpty() -> Bool {
        return true
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SearchOffenceViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOffenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "offenseidentifierCell") as! OffenseTableViewCell
        cell.title.text = filteredOffenses[indexPath.row].tittle
        cell.number.text = filteredOffenses[indexPath.row].number
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier:"DescriptionOffenseViewController") as! DescriptionOffenseViewController! {
            vc.offence = filteredOffenses[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}



