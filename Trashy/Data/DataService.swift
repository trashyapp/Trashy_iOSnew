//
//  DataService.swift
//  Trashy
//
//  Created by Kai Zheng on 25.06.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_PRODUKT = DB_BASE.child("produkt")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_PRODUKT: DatabaseReference {
        return _REF_PRODUKT
    }
    
    /*func addDBProdukt(pID: String, produktData: Dictionary<String, Any>) {
        REF_PRODUKT.child(pID).updateChildValues(produktData)
    }*/
    
    func getProdukt(pID: String) {
        REF_PRODUKT.observe(.value, with: { (produkt) in
        })
    }
}

















