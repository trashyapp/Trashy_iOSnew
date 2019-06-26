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
                let produktNummer = produkt.childSnapshot(forPath: "produktNummer").value as! Int
                let barcodeNummer = produkt.childSnapshot(forPath: "barcodeNummer").value as! String
                let produktName = produkt.childSnapshot(forPath: "produktName").value as! String
                let produktMaterialien = produkt.childSnapshot(forPath: "produktMaterialien").value as! String
                let produktBild = produkt.childSnapshot(forPath: "produktBild").value as! Int
                let letzteAenderung = produkt.childSnapshot(forPath: "letzteAenderung").value as! String
                
                if code == barcodeNummer {
                    let produktMaterialienArrayString = produktMaterialien.split(separator: ",")
                    let produktMaterialienArray = produktMaterialienArrayString.map { Int($0)! }
                    
                    let produkt = Produkt(produktNummer: produktNummer, barcodeNummer: barcodeNummer, produktName: produktName, produktMaterialien: produktMaterialienArray, produktBild: produktBild, letzteAenderung: letzteAenderung)
                    
                    produktArray.append(produkt)
                } else {
                    let produkt = Produkt(produktNummer: -1, barcodeNummer: code, produktName: "-1", produktMaterialien: [-1], produktBild: -1, letzteAenderung: "-1")
                    
                    produktArray.append(produkt)
                }
            }
            handler(produktArray)
        }
    }
}

















