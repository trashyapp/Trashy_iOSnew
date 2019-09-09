//
//  Algorithmus.swift
//  Trashy
//
//  Created by Kai Zheng on 06.09.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import Foundation

class Algorithmus {
    var place: PlaceData!
    var places = [Place]()
    var trash: TrashData!
    var trashDataArray = [Trash]()
    var trashNumber: Int
    
    init() {
        place = PlaceData()
        places = place.places
        trash = TrashData()
        trashDataArray = trash.trashDataArray
        trashNumber = 1
    }
    
    func algorithmus(materials: [String]) -> Int {
        for i in 0..<places.count {
            if places[i].active {
                switch places[i].place {
                case "Germany":
                    trashNumber = algorithmusGermany(materials: materials)
                case "Zurich":
                    print(".")
                default: break
                }
            }
        }
        
        return trashNumber
    }
    
    func algorithmusGermany(materials: [String]) -> Int {
        print("DAAAA ++++ \(materials)")
        
        for i in 0..<materials.count {
            if (materials[i] == "Plastik") || (materials[i] == "Kunststoff") || (materials[i] == "Hart Plastik") || (materials[i] == "Metall") || (materials[i] == "Aluminium") || (materials[i] == "Blech") {
                return trashDataArray[3].trashNumber
            }
            if (materials[i] == "Papier") || (materials[i] == "Pappe") {
                trashNumber = 1
            }
            if materials[i] == "Bio" {
                return trashDataArray[2].trashNumber
            }
            if materials[i] == "Glas" {
                trashNumber = 0
            }
        }
        return trashNumber
    }
}
