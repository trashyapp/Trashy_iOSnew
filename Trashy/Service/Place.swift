//
//  Place.swift
//  Trashy
//
//  Created by Kai Zheng on 03.07.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import Foundation

struct Place {
    private var _place: String
    private var _active: Bool
    
    init(place: String, active: Bool) {
        self._place = place
        self._active = active
    }
    
    var place: String {
        return _place
    }
    
    var active: Bool {
        return _active
    }
}

struct PlaceData {
    var places = [
        Place(place: "Zurich", active: false),
        Place(place: "Germany", active: true)
    ]
}

