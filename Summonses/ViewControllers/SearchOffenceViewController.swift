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
    var CustomizeViewController = "FAVOURITES"
    var classTypeName = ""
    let searchController = UISearchController(searchResultsController: nil)
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        offenses =  Array(DataBaseManager.shared.realm.objects(OffenseModel.self).filter("classType == %@", classTypeName))
        filteredOffenses = offenses

        tableView.alwaysBounceVertical = false
        searchController.searchBar.layer.borderWidth = 1
        searchController.searchBar.layer.borderColor = UIColor.customGray.cgColor
        searchController.searchBar.backgroundColor = .customGray
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = .customGray
        searchController.searchBar.tintColor = .customGray
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } 
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        tableView.register(UINib(nibName: "OffenseTableViewCell", bundle: nil), forCellReuseIdentifier: "offenseidentifierCell")
        NotificationCenter.default.addObserver(self, selector: #selector(SearchOffenceViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        tableView.reloadData()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backgroundView = UIView()
        backgroundView.backgroundColor = StyleManager.getAppStyle().backgrounColorForView()
        self.tableView.backgroundView = backgroundView
    
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
          tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.cgRectValue.height, 0)
            
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            filteredOffenses = offenses.filter({ (it)  -> Bool in
                return it.isFavourite == true
            })
        } else {
            filteredOffenses = offenses.filter { $0.title.lowercased().contains(searchController.searchBar.text!.lowercased()) || $0.number.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        if !searchController.isActive {
            filteredOffenses = offenses
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
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
    

    func addToFavourite(_ offence: OffenseModel) {
        do {
            try DataBaseManager.shared.realm.write {
                offence.isFavourite = !offence.isFavourite
            }
        } catch {
            fatalError()
        }
        
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

extension SearchOffenceViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOffenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "offenseidentifierCell") as! OffenseTableViewCell
        let offense = filteredOffenses[indexPath.row]
        cell.configure(with: offense)
        cell.onFavouritesPress = { [unowned self] in
            self.addToFavourite(offense)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
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
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y < 0 {
//            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
//        }
//    }
}



