//
//  MenuOffenceViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit
import IceCream
import SwiftyUserDefaults

class MenuOffenceViewController: BaseViewController , UICollectionViewDataSource, UICollectionViewDelegate {
    
    var tableData: [Dictionary<String,Any>] = [["name": "A-SUMMONS", "image": #imageLiteral(resourceName: "parcing_icon"), "className": "A"],
                                               ["name": "B-SUMMONS", "image": #imageLiteral(resourceName: "cars_icon"), "className": "B"],
                                               ["name": "C-SUMMONS", "image": #imageLiteral(resourceName: "city_hall"), "className": "C"],
                                               ["name": "OATH-SUMMONS", "image": #imageLiteral(resourceName: "libra"), "className": "OATH"],
                                               ["name": "TAB-SUMMONS", "image": #imageLiteral(resourceName: "train"), "className": "TAB"],
                                               ["name": "ECB-SUMMONS", "image": #imageLiteral(resourceName: "parkplace"), "className": "ECB"]]
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var items: [Section] = [.offenseViews]
    
    var offenses: [OffenseModel] = []
    var filteredOffenses = [OffenseModel]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title = "Summonses"
        self.tabBarItem.title = "Summonses"
        self.tabBarItem.image = #imageLiteral(resourceName: "tabbar_summons")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.bgMainCell
        tableView.isHidden = true
        
        self.searchBar.delegate = self
        searchBar.placeholder = "Search and Favorites List"
        
        registerCells()
        
        //    NotificationCenter.default.addObserver(self, selector:#selector(reloadView), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
    }
    
    //      @objc func reloadView() {
    //          if SettingsManager.shared.needsOpenOvertimeHistory == true
    //                      ||  SettingsManager.shared.needsOpenOvertimeCalculator == true {
    ////                      let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    ////                      if let vc = storyboard.instantiateViewController(withIdentifier: "OvertimePageViewController") as? OvertimePageViewController {
    ////                          self.present(vc, animated: false, completion: nil)
    ////                      }
    //                let pageVC = OvertimePageViewController()
    //                //self.present(vc, animated: false, completion: nil)
    //                navigationController?.pushViewController(pageVC, animated: false)
    //            }
    //
    //                  SettingsManager.shared.needsOpenOvertimeHistory = false
    //                  SettingsManager.shared.needsOpenOvertimeCalculator = false
    //      }
    
    override func viewDidAppear(_ animated: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let targetVC = storyboard.instantiateViewController(withIdentifier :"OvertimePageViewController") as! OvertimePageViewController
        
        //self.present(pageVC, animated: true, completion: nil)
        //navigationController?.pushViewController(targetVC, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        offenses =  Array(DataBaseManager.shared.realm.objects(OffenseModel.self))
    }
    
    func registerCells() {
        self.collectionView.register(UINib(nibName: "MenueCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MenueCollectionViewCell")
        self.tableView.register(UINib(nibName: "OffenseTableViewCell", bundle: nil), forCellReuseIdentifier: "offenseidentifierCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = collectionView.bounds.width / 2 - 15
            let itemHeight = collectionView.bounds.height / 3 - 10
            
            layout.itemSize = CGSize(width: itemWidth , height: itemHeight)
            layout.minimumLineSpacing = 10
            layout.invalidateLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenueCollectionViewCell.className, for: indexPath) as! MenueCollectionViewCell
        
        cell.configure(with: tableData[indexPath.row]["name"] as? String, image: tableData[indexPath.row]["image"] as? UIImage)
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let searchOffenceVC = self.storyboard?.instantiateViewController(withIdentifier: SearchOffenceViewController.className) as? SearchOffenceViewController, let purchaseVC = self.storyboard?.instantiateViewController(withIdentifier: NewInAppPurchaseVC.className) as? NewInAppPurchaseVC {
            searchOffenceVC.title = tableData[indexPath.row]["name"] as? String
            searchOffenceVC.classTypeName = tableData[indexPath.row]["className"] as! String
            
            if Defaults[.proBaseVersion] || Defaults[.endlessVersion] || Defaults[.proBaseVersion] {
                self.navigationController?.pushViewController(searchOffenceVC, animated: true)
            } else if !Defaults[.yearSubscription] || !Defaults[.endlessVersion] || !Defaults[.proBaseVersion] {
                self.present(purchaseVC, animated: true)
            }
        }
    }
}

extension MenuOffenceViewController : UITableViewDataSource, UITableViewDelegate {
    
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
            self.navigationController?.setNavigationBarHidden(false, animated: true)
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
            let favOffenses = Array(DataBaseManager.shared.realm.objects(OffenseModel.self).filter("isFavourite == true"))
            if favOffenses.count != 0 {
                filteredOffenses = favOffenses
            }
        }
        
        tableView.reloadData()
    }
}

extension MenuOffenceViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        collectionView.isHidden = true
        tableView.isHidden = false
        refilter()
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        refilter()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        //        collectionView.isHidden = false
        //        tableView.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        searchBar.text = ""
        collectionView.isHidden = false
        tableView.isHidden = true
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

extension MenuOffenceViewController {
    
    fileprivate enum Section: Int {
        case emptyDataView, offenseViews
    }
}
