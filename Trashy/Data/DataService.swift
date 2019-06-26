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
    
    func getProdukt(code: String, handler: @escaping (_ produkt: [Produkt]) -> ()) {
        var produktArray = [Produkt]()
        
        REF_PRODUKT.observeSingleEvent(of: .value) { (produktSnapshot) in
            guard let produktSnapshot = produktSnapshot.children.allObjects as? [DataSnapshot] else {
                print("something is not right")
                return
            }
            
            for produkt in produktSnapshot {
                let barcodeNummer = produkt.childSnapshot(forPath: "barcodeNummer").value as! String
                let produktName = produkt.childSnapshot(forPath: "produktName").value as! String
                let produktHersteller = produkt.childSnapshot(forPath: "produktHersteller").value as! String
                let produktBild = produkt.childSnapshot(forPath: "produktBild").value as! Int
                //let produktMaterialien = produkt.childSnapshot(forPath: "produktMaterialien").value as! [String]
                
                if code == barcodeNummer {
                    let produkt = Produkt(barcodeNummer: barcodeNummer, produktName: produktName, produktHersteller: produktHersteller, produktBild: produktBild/*, produktMaterialien: produktMaterialien*/)
                    
                    print(code)
                    print(barcodeNummer)
                    
                    produktArray.append(produkt)
                } else {
                    //case: this product is not yet in database
                }
            }
            handler(produktArray)
        }
    }
}

















