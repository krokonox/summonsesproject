//
//  ReferenceDetailViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 12/26/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit
import WebKit

class ReferenceDetailViewController: BaseViewController {
  
  let webView: WKWebView = {
    let webView = WKWebView(frame: .zero)
    webView.isOpaque = true
    return webView
  }()
  
  var reference: ReferenceModel?
	var filename: String = ""
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setupView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  private func setupView() {
    if let ref = reference {
      title = ref.name
      self.view.addSubview(webView)
      
      let filePath = Bundle.main.path(forResource: "\(filename)", ofType: "html")
      let fileURL = URL(fileURLWithPath: filePath!)
      webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
      webView.navigationDelegate = self
    }
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    addConstraintsWebView()
  }
  
  private func addConstraintsWebView() {
    webView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: self.view, attribute: .centerX, relatedBy: .equal, toItem: webView, attribute: .centerX, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: self.view, attribute: .centerY, relatedBy: .equal, toItem: webView, attribute: .centerY, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: webView, attribute: .height, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: self.view, attribute: .width, relatedBy: .equal, toItem: webView, attribute: .width, multiplier: 1, constant: 0)
      ])
  }
}

extension ReferenceDetailViewController: WKNavigationDelegate {
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    let css = "body { background-color: #e8edf5 !important; }"
    let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
    webView.evaluateJavaScript(js, completionHandler: nil)
  }
  
}
