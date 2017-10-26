//
//  MainViewController.swift
//  Summonses
//
//  Created by Artsiom Shmaenkov on 10/25/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet var viewGroup: [UIView]?
    @IBOutlet var labelGroup: [UILabel]?
    @IBOutlet var textViewGroup: [UITextView]?
    @IBOutlet var tableViewGroup: [UITableView]?
    @IBOutlet var collectionViewGroup: [UICollectionView]?
    @IBOutlet var tableViewCellGroup: [UITableViewCell]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let menuButton = UIBarButtonItem()
//        menuButton.image = UIImage(contentsOfFile: "icon_settings")
//        menuButton.action = #selector(pushSettingsViewController)
//        
//        navigationController?.navigationItem.rightBarButtonItems?.append(menuButton)
    }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        
        updateStyle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateStyle() {
        StyleManager.updateStyleForViews(viewGroup:viewGroup)
        StyleManager.updateStyleForLabel(labelGroup:labelGroup)
        StyleManager.updateStyleForTextView(textViewGroup:textViewGroup)
        StyleManager.updateStyleForTableView(tableViewGroup:tableViewGroup)
        StyleManager.updateStyleForCollectionView(collectionViewGroup:collectionViewGroup)
    }
    
    func pushSettingsViewController() {
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
