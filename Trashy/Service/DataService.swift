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
    var algorithmus: Algorithmus!
    
    var materialArray = [Material]()
    var produktArray = [Produkt]()
    var materialNameArray = [String]()
    
    var trashNumber: Int
    
    init() {
        place = PlaceData()
        places = place.places
        algorithmus = Algorithmus()
        self.trashNumber = 0
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
            
            self.produktArray = [Produkt]()
            
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
            
            self.materialArray = [Material]()
            
            for i in 0..<materials.count {
                for material in materialSnapshot {
                    let materialNummer = material.childSnapshot(forPath: "materialNummer").value as! Int
                    let materialName = material.childSnapshot(forPath: "materialName").value as! String
                    let materialBeschreibung = material.childSnapshot(forPath: "materialBeschreibung").value as! String
                    let materialBild = material.childSnapshot(forPath: "materialBild").value as! Int
                    let umwelt = material.childSnapshot(forPath: "umwelt").value as! Int
                    
                    if materials[i] == materialNummer {
                        let material = Material(materialNummer: materialNummer, materialName: materialName, materialBeschreibung: materialBeschreibung, materialBild: materialBild, umwelt: umwelt)
                        
                        print(material)
                        self.materialArray.append(material)
                    }
                    if materials[0] == -1 {
                        let material = Material(materialNummer: materialNummer, materialName: materialName, materialBeschreibung: materialBeschreibung, materialBild: materialBild, umwelt: umwelt)
                        
                        print(material)
                        self.materialArray.append(material)
                    }
                }
            }
            handler(self.materialArray)
        }
    }
    
    func getSelectedData(code: String, handler: @escaping (_ selectedData: [Any]) -> ()) {
        var selectedDataArray = [Any]()
        
        produktArray = [Produkt]()
        materialArray = [Material]()
        materialNameArray = [String]()
        trashNumber = 0
        
        DataService.instance.getProdukt(code: code) { (returnedProduktArray) in
            
            print("---------------------------")
            print(self.produktArray)
            print(returnedProduktArray)
            print("---------------------------")
            
            self.produktArray = returnedProduktArray
            
            if self.produktArray.count != 0 {
                DispatchQueue.main.async {
                    DataService.instance.getMaterial(materials: self.produktArray[0].produktMaterialien) { (returnedMaterialArray) in
                        self.materialArray = returnedMaterialArray
                        
                        for i in 0..<self.materialArray.count {
                            for k in 0..<self.produktArray[0].produktMaterialien.count {
                                if self.produktArray[0].produktMaterialien[k] == self.materialArray[i].materialNummer {
                                    self.materialNameArray.append(self.materialArray[i].materialName)
                                }
                            }
                        }
                        
                        self.trashNumber = self.algorithmus.algorithmus(materials: self.materialNameArray)
                        
                        print("trashNumber: \(self.trashNumber)")
                        
                        selectedDataArray.removeAll()
                        selectedDataArray.append(self.produktArray)
                        selectedDataArray.append(self.materialArray)
                        selectedDataArray.append(self.trashNumber)
                        
                        handler(selectedDataArray)
                    }
                }
            }
            selectedDataArray.append(self.produktArray)
            selectedDataArray.append(self.materialArray)
            selectedDataArray.append(self.trashNumber)
            
            print(selectedDataArray)
            
            handler(selectedDataArray)
        }
    }
}

















