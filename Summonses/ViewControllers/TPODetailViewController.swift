//
//  TPODetailViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 12/18/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit
import WebKit

class TPODetailViewController: BaseViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    var tpo: TPOModel?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupView() {
        if let tpo = tpo {
            title = tpo.name
            descriptionTextView.text = tpo.descriptionTPO
        }
    }
}
