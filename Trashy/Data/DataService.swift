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
    var place: PlaceData!
    var places = [Place]()
    var trash: TrashData!
    var trashDataArray = [Trash]()
    
    var materialArray = [Material]()
    var produktArray = [Produkt]()
    
    init() {
        place = PlaceData()
        places = place.places
        trash = TrashData()
        trashDataArray = trash.trashDataArray
    }
    
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_PRODUKT = DB_BASE.child("produkt")
    private var _REF_MATERIAL = DB_BASE.child("material")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_PRODUKT: DatabaseReference {
        return _REF_PRODUKT
    }
    
    var REF_MATERIAL: DatabaseReference {
        return _REF_MATERIAL
    }
    
    func getProdukt(code: String, handler: @escaping (_ produkt: [Produkt]) -> ()) {
        for i in 0..<places.count {
            
            if places[i].active {
                switch places[i].place {
                case "Germany":
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
                                
                                self.produktArray.append(produkt)
                            } else {
                                let produkt = Produkt(produktNummer: -1, barcodeNummer: code, produktName: "-1", produktMaterialien: [-1], produktBild: -1, letzteAenderung: "-1")
                                
                                self.produktArray.append(produkt)
                            }
                        }
                        handler(self.produktArray)
                    }
                case "Zurich":
                    print("Zurich")
                default:
                    break
                }
            }
        }
    }
    
    func getMaterial(materials: [Int], handler: @escaping (_ material: [Material]) -> ()) {
        REF_MATERIAL.observeSingleEvent(of: .value) { (materialSnapshot) in
            guard let materialSnapshot = materialSnapshot.children.allObjects as? [DataSnapshot] else {
                print("something is not right")
                return
            }
            
            for material in materialSnapshot {
                let materialNummer = material.childSnapshot(forPath: "materialNummer").value as! Int
                let materialName = material.childSnapshot(forPath: "materialName").value as! String
                let materialBeschreibung = material.childSnapshot(forPath: "materialBeschreibung").value as! String
                let materialBild = material.childSnapshot(forPath: "materialBild").value as! Int
                let umwelt = material.childSnapshot(forPath: "umwelt").value as! Int
                
                //falsch
                for i in 0..<materials.count {
                    if materials[i] == materialNummer {
                        let material = Material(materialNummer: materialNummer, materialName: materialName, materialBeschreibung: materialBeschreibung, materialBild: materialBild, umwelt: umwelt)
                        
                        self.materialArray.append(material)
                    }
                }
            }
            handler(self.materialArray)
        }
    }
    
    func getSelectedData(code: String, handler: @escaping (_ selectedData: [Any]) -> ()) {
        var selectedDataArray = [Any]()
        
        DataService.instance.getProdukt(code: code) { (returnedProduktArray) in
            self.produktArray = returnedProduktArray
            
            DispatchQueue.main.async {
                DataService.instance.getMaterial(materials: self.produktArray[0].produktMaterialien) { (returnedMaterialArray) in
                    self.materialArray = returnedMaterialArray
                    
                    selectedDataArray.append(self.produktArray)
                    selectedDataArray.append(self.materialArray)
                    
                    handler(selectedDataArray)
                }
            }
        }
    }
}

















