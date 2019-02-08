//
//  DescriptionOffenseViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/16/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit

class DescriptionOffenseViewController: BaseViewController {
  
  
  @IBOutlet weak var priceLabel:          UILabel!
  @IBOutlet weak var lawLabel:            UILabel!
  @IBOutlet weak var classNameLabel:      UILabel!
  @IBOutlet weak var numberLabel:         UILabel!
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var actionsView:         UIView!
  @IBOutlet weak var bgSegmentView:       UIView!
  @IBOutlet weak var sergemtControl:      UISegmentedControl!
  @IBOutlet weak var typeLabel:           UILabel!
  @IBOutlet weak var shareButton:         UIButton!
  
  @IBOutlet weak var codeLabel: UILabel!
  var offence : OffenseModel!
  var image = UIImage(named: "ic_plus")
  
  @IBOutlet weak var descriptionToViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var descriptionToSegmentControlConstraint: NSLayoutConstraint!
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.titleView = UIView(frame: CGRect(origin: .zero, size: navigationController?.navigationBar.frame.size ?? .zero))
    self.setNavigationButton()
    setupView()
    setupUI()
    view.setNeedsLayout()
  }
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @objc func checkSegment(segment: UISegmentedControl) {
		
		if !IAPHandler.shared.proBaseVersion {
			IAPHandler.shared.showIAPVC(.fullSummonses) { (vc) in
				guard let vc = vc else { return }
				self.present(vc, animated: true, completion: nil)
			}
			segment.selectedSegmentIndex = 0
			return
		}
		
    if segment.selectedSegmentIndex == 0 {
      descriptionTextView.text = offence.descriptionOffense
    } else if segment.selectedSegmentIndex == 1 {
      descriptionTextView.text = offence.testimony
    }
  }
  
  @objc func setFavouriteProduct() {
		if IAPHandler.shared.proBaseVersion {
			do {
				try DataBaseManager.shared.realm.write {
					if offence.isFavourite {
						offence.isFavourite = false
					} else {
						offence.isFavourite = true
					}
				}
				self.setNavigationButton()
			} catch {
				print(error)
			}
		} else {
			IAPHandler.shared.showIAPVC(.fullSummonses) { (vc) in
				guard let vc = vc else { return }
				self.present(vc, animated: true, completion: nil)
			}
		}
  }
  
  private func setNavigationButton() {
    if offence.isFavourite {
      image = UIImage(named: "ic_check")
    } else {
      image = UIImage(named: "ic_plus")
    }
    let menuButton = UIBarButtonItem(image:image, style: .plain, target: self, action: #selector(setFavouriteProduct))
    navigationItem.rightBarButtonItem =  menuButton
  }
  
  
  @IBAction func onSharePress(_ sender: Any) {
    let subject = "New testimony submission: \(offence.number)"
    let coded = "mailto:\(K.appConfig.supportEmail)?subject=\(subject)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    if let url = URL(string: coded!) {
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      } else {
        UIApplication.shared.openURL(url)
      }
    }
  }
  
  @IBAction func onTestmonyPress(_ sender: Any) {
    if let vc = self.storyboard?.instantiateViewController(withIdentifier: TestimonyViewController.className) as? TestimonyViewController {
      vc.offence = offence
      self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
  }
  
  @IBAction func onCustomizePress(_ sender: Any) {
    if let vc = self.storyboard?.instantiateViewController(withIdentifier: CustomizeViewController.className) as? CustomizeViewController {
      vc.offence = offence
      self.navigationController?.pushViewController(vc, animated: true)
    }
    
  }
  
  private func setupView() {
    lawLabel.text =         offence.law
    numberLabel.text =      offence.number
    typeLabel.text =        offence.classType
    classNameLabel.text =   offence.type
    priceLabel.text =       offence.price
    codeLabel.text =        offence.code
    descriptionTextView.text = offence.descriptionOffense
    descriptionTextView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    if offence.testimony.isEmpty {
      descriptionToSegmentControlConstraint.isActive = false
      descriptionToViewConstraint.isActive = true
      sergemtControl.isHidden = true
    }
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    view.setNeedsUpdateConstraints()
  }
  
  func setupUI(){
    updateViewConstraints()
    bgSegmentView.layer.cornerRadius = CGFloat.cornerRadius4
    bgSegmentView.clipsToBounds = true
    bgSegmentView.backgroundColor = .white
    self.automaticallyAdjustsScrollViewInsets = false
    descriptionTextView.tintColor = .customBlue
    descriptionTextView.textColor = .darkBlue2
    descriptionTextView.backgroundColor = .bgMainCell
    sergemtControl.addTarget(self, action: #selector(checkSegment(segment:)), for: .valueChanged)
    sergemtControl.tintColor = UIColor.customBlue1
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    descriptionTextView.setContentOffset(CGPoint.zero, animated: false)
    
    let label = UILabel(frame: CGRect(origin: .zero, size: navigationItem.titleView?.frame.size ?? .zero))
    label.backgroundColor = .clear
    label.numberOfLines = 0
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 18.0)
    label.textColor = .darkBlue
    label.text = offence.title
    label.adjustsFontSizeToFitWidth = true
    navigationItem.titleView?.addSubview(label)
  }
}
