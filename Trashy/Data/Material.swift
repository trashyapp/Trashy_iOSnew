//
//  Material.swift
//  Trashy
//
//  Created by Kai Zheng on 26.06.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import Foundation

class Material {
    private var _materialNummer: Int
    private var _materialName: String
    private var _materialBeschreibung: String
    private var _materialBild: Int
    private var _umwelt: Int
    
    init(materialNummer: Int, materialName: String, materialBeschreibung: String, materialBild: Int, umwelt: Int) {
        self._materialNummer = materialNummer
        self._materialName = materialName
        self._materialBeschreibung = materialBeschreibung
        self._materialBild = materialBild
        self._umwelt = umwelt
    }
    
    var materialNummer: Int {
        return _materialNummer
    }
    
    var materialName: String {
        return _materialName
    }
    
    var materialBeschreibung: String {
        return _materialBeschreibung
    }
    
    var materialBild: Int {
        return _materialBild
    }
    
    var umwelt: Int {
        return _umwelt
    }
}
