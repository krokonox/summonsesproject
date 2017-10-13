//
//  ViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 10/13/17.
//  Copyright © 2017 neoviso. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class ViewController: UIViewController {
    let realm = AppDelegate.realm()

    override func viewDidLoad() {
        super.viewDidLoad()
         readJson()
        
        let offences = Array(realm.objects(OffenseModel.self))
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func readJson() {
        do {
            if let file = Bundle.main.url(forResource: "Contents", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let jsonValue = JSON(data: data)
                
                var offences: [OffenseModel] = []
                for subJson in jsonValue.arrayValue {
                    let offence = OffenseModel(value: subJson.offenseModelValue())
                    print(offence)
                    offences.append(offence)
                }
                
                let tempRealm = realm
                do {
                    try tempRealm.write {
                        tempRealm.add(offences, update: true)
                    }
                }
            } else {
                print("no  file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    
    
}

