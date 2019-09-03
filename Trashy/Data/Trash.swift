//
//  Trash.swift
//  Trashy
//
//  Created by Kai Zheng on 03.07.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import Foundation

struct Trash {
    private var _trashNumber: Int
    private var _trashText: String
    private var _trashImage: String
    private var _trashColor: String
    
    init(trashNumber: Int, trashText: String, trashImage: String, trashColor: String) {
        self._trashNumber = trashNumber
        self._trashText = trashText
        self._trashImage = trashImage
        self._trashColor = trashColor
    }
    
    var trashNumber: Int {
        return _trashNumber
    }

    var trashText: String {
        return _trashText
    }
    
    var trashImage: String {
        return _trashImage
    }
    
    var trashColor: String {
        return _trashColor
    }
}

class TrashData {
    var place: PlaceData!
    var places = [Place]()
    var trashDataArray = [Trash]()
    
    init() {
        place = PlaceData()
        places = place.places
        initTrashDataArray()
    }
    
    func initTrashDataArray() {
        for i in 0..<places.count {
            if places[i].active {
                switch places[i].place {
                case "Germany":
                    trashDataArray = [
                        Trash(trashNumber: 1, trashText: "Papier", trashImage: "GER_TrashBlueImage", trashColor: "TrashBlue"),
                        Trash(trashNumber: 2, trashText: "Rest-Stoffe", trashImage: "GER_TrashGreyImage", trashColor: "TrashGrey"),
                        Trash(trashNumber: 3, trashText: "Bio-Müll", trashImage: "GER_TrashBrownImage", trashColor: "TrashBrown"),
                        Trash(trashNumber: 4, trashText: "Wert-Stoffe", trashImage: "GER_TrashYellowImage", trashColor: "TrashYellow")
                    ]
                case "Zurich":
                    print(".")
                default: break
                }
            }
        }
    }
}
