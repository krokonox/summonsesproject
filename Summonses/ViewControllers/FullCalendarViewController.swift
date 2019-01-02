//
//  FullCalendarViewController.swift
//  Summonses
//
//  Created by Smikun Denis on 02.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

let fullCalendarCellIdentfier = "FullCalendarCollectionViewCell"

class FullCalendarViewController: BaseViewController {
    
    @IBOutlet weak var headerCalendarView: UIView!
    @IBOutlet weak var calendarView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.parent?.navigationItem.title = "RDO Calendar"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        if let layout = calendarView.collectionViewLayout as? UICollectionViewFlowLayout {
//            let itemWidth = calendarView.bounds.width / 3
//            let itemHeight = calendarView.bounds.height / 4
//
//            layout.itemSize = CGSize(width: itemWidth , height: itemHeight)
////            layout.minimumLineSpacing = 10
////            layout.minimumInteritemSpacing = 10
//            layout.invalidateLayout()
//
//        }
    }
    
    private func setupViews() {
        headerCalendarView.layer.cornerRadius = 4.0
        calendarView.layer.cornerRadius = 4.0
        self.view.backgroundColor = UIColor.bgMainCell
        
        setupCalendarView()
    }
    
    private func setupCalendarView() {
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        
        registerCollectionCells()
    }
    
    private func registerCollectionCells() {
//        calendarView.register(UINib(nibName: fullCalendarCellIdentfier, bundle: nil), forCellWithReuseIdentifier: fullCalendarCellIdentfier)
    }
    
}

extension FullCalendarViewController: UICollectionViewDelegate {}

extension FullCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let calendarViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: fullCalendarCellIdentfier, for: indexPath) as? FullCalendarCollectionViewCell else { fatalError() }
        
        calendarViewCell.setupViews()
        
        return calendarViewCell
    }
}

extension FullCalendarViewController: UICollectionViewDelegateFlowLayout {}
