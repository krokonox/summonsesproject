//
//  MenuOffenceViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit


class MenuOffenceViewController: BaseSettingsViewController , UICollectionViewDataSource, UICollectionViewDelegate {
    
    var tableData: [Dictionary<String,String>] = [["name": "A-SUMMONS", "image": "parking", "className": "A"],
                                                  ["name": "B-SUMMONS", "image": "car", "className": "B"],
                                                  ["name": "C-SUMMONS", "image": "city-hall", "className": "C"],
                                                  ["name": "OATH", "image": "libra", "className": "OATH"],
                                                  ["name": "TAB", "image": "train", "className": "TAB"],
                                                  ["name": "ECB", "image": "pine-tree", "className": "ECB"]]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title = "SUMMONSES"
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
            let itemWidth = collectionView.bounds.width / 2 - 30
            let itemHeight = collectionView.bounds.height / 3 - 20 
            //layout.
           
            layout.itemSize = CGSize(width: itemWidth , height: itemHeight)
//            layout.minimumInteritemSpacing = (view.bounds.width - (view.bounds.width / 2.5) * 2) - 40
//            layout.minimumLineSpacing = (view.bounds.width - (view.bounds.width / 2.5) * 2) - 40
            layout.minimumLineSpacing = 20
            
            layout.invalidateLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MenueCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: MenueCollectionViewCell.className, for: indexPath) as! MenueCollectionViewCell

        cell.title.text = tableData[indexPath.row]["name"]
        cell.image.image = UIImage(named: tableData[indexPath.row]["image"]!)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) selected")
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: SearchOffenceViewController.className) as? SearchOffenceViewController {
            vc.title = tableData[indexPath.row]["name"]
            vc.classTypeName = tableData[indexPath.row]["className"]!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

