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
    private var _produktMaterialien: [Int]
    private var _produktBild: Int
    private var _letzteAenderung: String
    
    init(produktNummer: Int, barcodeNummer: String, produktName: String, produktMaterialien: [Int], produktBild: Int, letzteAenderung: String) {
        self._produktNummer = produktNummer
        self._barcodeNummer = barcodeNummer
        self._produktName = produktName
        self._produktMaterialien = produktMaterialien
        self._produktBild = produktBild
        self._letzteAenderung = letzteAenderung
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
    
    var produktMaterialien: [Int] {
        return _produktMaterialien
    }
    
    var produktBild: Int {
        return _produktBild
    }
    
    var letzteAenderung: String {
        return _letzteAenderung
    }
}
