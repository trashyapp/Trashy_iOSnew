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
    
    init() {
        place = PlaceData()
        places = place.places
        trash = TrashData()
        trashDataArray = trash.trashDataArray
    }
    
    func algorithmus(materials: [String]) -> Int {
        var trashNumber = 0
        
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
        for i in 0..<materials.count {
            switch materials[i] {
            case "Papier":
                return trash.trashDataArray[1].trashNumber
            default: break
            }
        }
        return 0
    }
}
