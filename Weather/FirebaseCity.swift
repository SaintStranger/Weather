//
//  FirebaseCity.swift
//  Weather
//
//  Created by Антон Чечевичкин on 22.04.2021.
//  Copyright © 2021 Антон Чечевичкин. All rights reserved.
//

import Foundation
import RealmSwift
import FirebaseDatabase

class FirebaseCity {
    
    let name: String
    let zipcode: Int
    let ref: DatabaseReference?
    var weathers = [Weather]()
    
    
    init(name: String, zipcode: Int, weathers: [Weather]) {
        self.ref = nil
        self.name = name
        self.zipcode = zipcode
        self.weathers = weathers
    }
    
    init?(snapshot: DataSnapshot, weathers: [Weather]) {
        guard let value = snapshot.value as? [String: Any],
              let zipcode = value["zipcode"] as? Int,
              let name = value["name"] as? String else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.name = name
        self.zipcode = zipcode
        self.weathers = weathers
    }
    
    
    func toAnyObject() -> [String: Any] {
        return [
            "name": name,
            "zipcode": zipcode
        ]
    }
    
}
