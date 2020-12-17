//
//  NYPDViewController.swift
//  Summonses
//
//  Created by Stanislav on 5/26/20.
//  Copyright © 2020 neoviso. All rights reserved.
//

import UIKit

class NYPDViewController: BaseViewController {
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
      stackView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 10),
        NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 10),
        NSLayoutConstraint(item: stackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 72),
        NSLayoutConstraint(item: stackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 199)
        ])
    }
    
    func setupViews() {
        var text = "NYPD Patrol Guide: Part 1"
        var textRange = NSMakeRange(0, text.count)
        var attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.linkColor, range: textRange)
        firstLabel.attributedText = attributedText
        
        text = "NYPD Patrol Guide: Part 2"
        textRange = NSMakeRange(0, text.count)
        attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.linkColor, range: textRange)
        secondLabel.attributedText = attributedText
        
        text = "NYPD Patrol Guide: Part 3"
        textRange = NSMakeRange(0, text.count)
        attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.linkColor, range: textRange)
        thirdLabel.attributedText = attributedText
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(onFirstLabelTap))
        firstLabel.isUserInteractionEnabled = true
        firstLabel.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(onSecondLabelTap))
        secondLabel.isUserInteractionEnabled = true
        secondLabel.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(onThirdLabelTap))
        thirdLabel.isUserInteractionEnabled = true
        thirdLabel.addGestureRecognizer(tap3)
        view.backgroundColor = .bgMainCell
    }
    
    @objc func onFirstLabelTap() {
        openPDF(1)
    }
    
    @objc func onSecondLabelTap() {
        openPDF(2)
    }
    
    @objc func onThirdLabelTap() {
        openPDF(3)
    }
    
    func openPDF(_ pdfNumber: Int) {
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "NYPDDetailViewController") as? NYPDDetailViewController else { return }
        detailVC.pdfNumber = pdfNumber
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

