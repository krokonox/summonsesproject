//
//  InAppPurchaseVC.swift
//  Summonses
//
//  Created by Vlad Lavrenkov on 2/7/19.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

class InAppPurchaseVC: UIViewController {
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var nameIAP: UILabel!
	@IBOutlet weak var descriptionIAP: UILabel!
	@IBOutlet weak var featuresIAP: UILabel!
	@IBOutlet weak var unlockButton: UIButton!
	@IBOutlet weak var pageControll: UIPageControl!
	@IBOutlet weak var backgroundSlider: UIView!
	
	var array = [String]()
	
	var typeIAP = NonConsumableType.fullSummonses
	
	override func viewDidLoad() {
		super.viewDidLoad()
		scrollView.delegate = self
		nameIAP.textColor = .darkBlue
		descriptionIAP.textColor = .darkBlue2
		featuresIAP.textColor = .darkBlue2
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		array.removeAll()
		
		switch typeIAP {
		case .fullSummonses:
			array.append("in_app_full1")
			array.append("in_app_full2")
			array.append("in_app_full3")
		case .otCalculator:
			array.append("in_app_overtime1")
			array.append("in_app_overtime2")
			array.append("in_app_overtime3")
		case .rdoCalendar:
			array.append("in_app_rdo1")
			array.append("in_app_rdo2")
//			array.append("in_app_overtime3")
		}
		
		scrollView.isPagingEnabled = true
		scrollView.contentSize = CGSize(width: backgroundSlider.bounds.width * CGFloat(array.count), height: backgroundSlider.bounds.height)
		pageControll.numberOfPages = array.count
		setSlider()
		
		switch typeIAP {
		case .fullSummonses:
			let fullSummonses = IAPHandler.shared.getProducts(.fullSummonses)
			nameIAP.text = fullSummonses?.localizedTitle ?? ""
			descriptionIAP.text = fullSummonses?.localizedDescription ?? ""
			unlockButton.setTitle("Unlock Overtime Calculator $\(fullSummonses?.price ?? 0)", for: .normal)
		case .otCalculator:
			let otCalculator = IAPHandler.shared.getProducts(.otCalculator)
			nameIAP.text = otCalculator?.localizedTitle ?? ""
			descriptionIAP.text = otCalculator?.localizedDescription ?? ""
			unlockButton.setTitle("Unlock Overtime Calculator $\(otCalculator?.price ?? 0)", for: .normal)
		case .rdoCalendar:
			let rdoCalendar = IAPHandler.shared.getProducts(.rdoCalendar)
			nameIAP.text = rdoCalendar?.localizedTitle ?? ""
			descriptionIAP.text = rdoCalendar?.localizedDescription ?? ""
			unlockButton.setTitle("Unlock Overtime Calculator $\(rdoCalendar?.price ?? 0)", for: .normal)
		}
		featuresIAP.text = "∙ Overtime Calculator\n∙ RDO Calendar\n∙ Most Commonly Used \"AT TPO\"\n∙ References"
	}
	
	func setSlider() {
		for (index, value) in array.enumerated() {
			if let sliderView = Bundle.main.loadNibNamed("SliderView", owner: self, options: nil)?.first as? SliderView {
				sliderView.imageView.image = UIImage(named: value)
				scrollView.addSubview(sliderView)
				sliderView.frame = scrollView.frame
				sliderView.frame.origin.x = CGFloat(index) * backgroundSlider.bounds.width
			}
		}
	}
	
	@IBAction func cancel() {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func unlockIAP() {
		IAPHandler.shared.upgratePro(typeIAP)
	}
	@IBAction func restoreIAP() {
		IAPHandler.shared.restorePro(typeIAP)
	}
	
}

extension InAppPurchaseVC: UIScrollViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let page = scrollView.contentOffset.x / scrollView.frame.width
		pageControll.currentPage = Int(page)
	}
	
}
