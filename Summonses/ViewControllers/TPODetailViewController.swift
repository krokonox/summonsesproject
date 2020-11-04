//
//  TPODetailViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 12/18/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit
import WebKit
import SwiftRichString

class TPODetailViewController: BaseViewController {
	
	@IBOutlet weak var descriptionTextView: UITextView!
	var tpo: TPOModel?
	
	let normal = Style {
        $0.font = UIFont(name: "SanFranciscoText-Light", size: 16.0)
	}
	let bold = Style {
		$0.font = UIFont(name: "SanFranciscoText-Semibold", size: 16.0)
	}
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupView()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.setNavigationBarHidden(false, animated: false)
	}
	
	private func setupView() {
        view.backgroundColor = .bgMainCell
		if let tpo = tpo {
			title = tpo.name
            
            let myGroup = StyleGroup(base: normal, ["bold": bold])//["bold": bold])
			let str = tpo.descriptionTPO
            
			descriptionTextView.attributedText = str.set(style: myGroup)
		}
	}
}
