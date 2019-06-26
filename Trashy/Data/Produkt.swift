//
//  Produkt.swift
//  Trashy
//
//  Created by Kai Zheng on 26.06.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import Foundation

class Produkt {
    private var _produktNummer: Int
    private var _barcodeNummer: String
    private var _produktName: String
    private var _produktHersteller: String
    private var _produktBild: Int
    private var _produktMaterialien: [Int]
    
    init(produktNummer: Int, barcodeNummer: String, produktName: String, produktHersteller: String, produktBild: Int, produktMaterialien: [Int]) {
        self._produktNummer = produktNummer
        self._barcodeNummer = barcodeNummer
        self._produktName = produktName
        self._produktHersteller = produktHersteller
        self._produktBild = produktBild
        self._produktMaterialien = produktMaterialien
    }
    
    var produktNummer: Int {
        return _produktNummer
    }
    
    var barcodeNummer: String {
        return _barcodeNummer
    }
    
    var produktName: String {
        return _produktName
    }
    
    var produktHersteller: String {
        return _produktHersteller
    }
    
    var produktBild: Int {
        return _produktBild
    }
    
    var produktMaterialien: [Int] {
        return _produktMaterialien
    }
}
