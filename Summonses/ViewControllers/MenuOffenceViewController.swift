//
//  MenuOffenceViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class MenuOffenceViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate {
    
    var tableData: [String] = ["A-SUMMONS", "B-SUMMONS", "C-SUMMONS","OATH","TAB","ECB"]
   // var tableImages: [String] = ["evox.jpg", "458.jpg", "gtr.jpg"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "SUMMONSES"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        registerCells()
        collectionView.backgroundColor = .clear
//        self.collectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        
    }
    
    func registerCells() {
       self.collectionView.register(UINib(nibName: "MenueCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MenueCollectionViewCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemWidth = view.bounds.width / 3.0
            let itemHeight = view.bounds.height / 3.0
            //layout.
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }
    
    // 2
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MenueCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenueCollectionViewCell", for: indexPath) as! MenueCollectionViewCell
        
        cell.title.text = tableData[indexPath.row]
        
       cell.image.image = UIImage(named: "icon_home")
        return cell
    }
    
    // 3
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) selected")
    }


  


}

