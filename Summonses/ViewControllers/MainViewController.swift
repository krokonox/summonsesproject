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
    @IBOutlet var buttonGroup: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStyle()
    }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func updateStyle() {
        StyleManager.updateStyleForViews(viewGroup:viewGroup)
        StyleManager.updateStyleForLabel(labelGroup:labelGroup)
        StyleManager.updateStyleForTextView(textViewGroup:textViewGroup)
        StyleManager.updateStyleForTableView(tableViewGroup:tableViewGroup)
        StyleManager.updateStyleForCollectionView(collectionViewGroup:collectionViewGroup)
    }
    
    @objc func pushSettingsViewController() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
