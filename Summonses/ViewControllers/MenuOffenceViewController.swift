//
//  MenuOffenceViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit


class MenuOffenceViewController: BaseSettingsViewController , UICollectionViewDataSource, UICollectionViewDelegate {
    
    var tableData: [String] = ["A-SUMMONS", "B-SUMMONS", "C-SUMMONS","OATH","TAB","ECB"]
    var tableImages: [String] = ["parking", "car","city-hall", "libra", "train", "city-hall"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        navigationItem.title = "SUMMONSES"
    }
    
    func registerCells() {
       self.collectionView.register(UINib(nibName: "MenueCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MenueCollectionViewCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = view.bounds.width / 2 - 30
            let itemHeight = view.bounds.height / 4
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
        let cell: MenueCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenueCollectionViewCell", for: indexPath) as! MenueCollectionViewCell

        cell.title.text = tableData[indexPath.row]
        cell.image.image = UIImage(named: tableImages[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) selected")
        if let vc = self.storyboard?.instantiateViewController(withIdentifier:"SearchOffenceViewController") as! SearchOffenceViewController! {
            vc.title = tableData[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

