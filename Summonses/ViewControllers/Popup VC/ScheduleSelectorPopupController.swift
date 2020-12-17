//
//  AddVocationPopupController.swift
//  Summonses
//
//  Created by Smikun Denis on 08.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

enum ItemType {
  case patrol
  case SRG
  case steadyRDO
  case customRDO
}

class ScheduleSelectorPopupController: BasePopupViewController {
  
  //MARK: Variables
  
    @IBOutlet weak var patrolView: UIView!
    @IBOutlet weak var srgView: UIView!
    @IBOutlet weak var steadyView: UIView!
    @IBOutlet weak var customView: UIView!
    
  var onItemSelected : ((ItemType)->())?
  
  //MARK: IBOutlet's
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    super.view.isUserInteractionEnabled = true
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
    super.view.addGestureRecognizer(tapGesture)
  }
    
  @objc private func onTap(_ gesture: UIGestureRecognizer) {
    if (gesture.state == .ended) {
        self.dismiss(animated: true, completion: nil)
        if patrolView.bounds.contains(gesture.location(in: patrolView)) {
            if let onItemSelected = onItemSelected {
                onItemSelected(.patrol)
            }
        }
        if srgView.bounds.contains(gesture.location(in: srgView)) {
            if let onItemSelected = onItemSelected {
                onItemSelected(.SRG)
            }
        }
        if steadyView.bounds.contains(gesture.location(in: steadyView)) {
            if let onItemSelected = onItemSelected {
                onItemSelected(.steadyRDO)
            }
        }
        if customView.bounds.contains(gesture.location(in: customView)) {
            if let onItemSelected = onItemSelected {
                onItemSelected(.customRDO)
            }
        }
        
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
}


