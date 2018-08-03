//
//  MenuOffenceViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit


class MenuOffenceViewController: BaseSettingsViewController , UICollectionViewDataSource, UICollectionViewDelegate {
    
    var tableData: [Dictionary<String,Any>] = [["name": "A-SUMMONS", "image": #imageLiteral(resourceName: "parcing_icon"), "className": "A"],
                                                  ["name": "B-SUMMONS", "image": #imageLiteral(resourceName: "cars_icon"), "className": "B"],
                                                  ["name": "C-SUMMONS", "image": #imageLiteral(resourceName: "city_hall"), "className": "C"],
                                                  ["name": "OATH", "image": #imageLiteral(resourceName: "libra"), "className": "OATH"],
                                                  ["name": "TAB", "image": #imageLiteral(resourceName: "train"), "className": "TAB"],
                                                  ["name": "ECB", "image": #imageLiteral(resourceName: "parkplace"), "className": "ECB"]]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title = "SUMMONSES"
        self.tabBarItem.title = "Summonses"
        self.tabBarItem.image = #imageLiteral(resourceName: "tabbar_summons")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func registerCells() {
       self.collectionView.register(UINib(nibName: "MenueCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MenueCollectionViewCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = collectionView.bounds.width / 2 - 15
            let itemHeight = collectionView.bounds.height / 3 - 10
            //layout.
           
            layout.itemSize = CGSize(width: itemWidth , height: itemHeight)
//            layout.minimumInteritemSpacing = (view.bounds.width - (view.bounds.width / 2.5) * 2) - 40
//            layout.minimumLineSpacing = (view.bounds.width - (view.bounds.width / 2.5) * 2) - 40
            layout.minimumLineSpacing = 10
            
            layout.invalidateLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenueCollectionViewCell.className, for: indexPath) as! MenueCollectionViewCell
        cell.title.text = tableData[indexPath.row]["name"] as? String
        cell.image.image = tableData[indexPath.row]["image"] as? UIImage
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) selected")
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: SearchOffenceViewController.className) as? SearchOffenceViewController {
            vc.title = tableData[indexPath.row]["name"] as? String
            vc.classTypeName = tableData[indexPath.row]["className"] as! String
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

