//
//  ReferenceModel.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 12/20/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class ReferenceModel: NSObject {
  
  var name: String = ""
  var fileName: String = ""
  
  override init() {
    super.init()
  }
  
  init(name: String, fileName: String) {
    super.init()
    self.name = name
    self.fileName = fileName
  }
  
}
