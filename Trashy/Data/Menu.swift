//
//  Menu.swift
//  Trashy
//
//  Created by Kai Zheng on 03.07.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import Foundation

struct Menu {
    private var _kategorie: String
    private var _menuText: String
    private var _menuImage: String
    
    init(kategorie: String, menuText: String, menuImage: String) {
        self._kategorie = kategorie
        self._menuText = menuText
        self._menuImage = menuImage
    }
    
    var kategorie: String {
        return _kategorie
    }
    
    var menuText: String {
        return _menuText
    }
    
    var menuImage: String {
        return _menuImage
    }
}

class MenuData {
    var place: PlaceData!
    var places = [Place]()
    var menuDataArray = [Menu]()
    
    init() {
        place = PlaceData()
        places = place.places
        initMenuDataArray()
    }
    
    func initMenuDataArray() {
        for i in 0..<places.count {
            if places[i].active {
                switch places[i].place {
                case "Germany":
                    menuDataArray = [
                        Menu(kategorie: "SettingsN", menuText: "Einstellungen", menuImage: "MenuEinstellungen"),
                        Menu(kategorie: "About", menuText: "Trashy", menuImage: "MenuTrashy"),
                        Menu(kategorie: "About", menuText: "Über Uns", menuImage: "MenuUeberUns"),
                        Menu(kategorie: "Trash", menuText: "Wert-Stoffe", menuImage: "MenuEimerGelb"),
                        Menu(kategorie: "Trash", menuText: "Papier", menuImage: "MenuEimerBlau"),
                        Menu(kategorie: "Trash", menuText: "Rest-Stoffe", menuImage: "MenuEimerGrau"),
                        Menu(kategorie: "Trash", menuText: "Bio-Müll", menuImage: "MenuEimerBraun"),
                        Menu(kategorie: "Trash", menuText: "Glas", menuImage: "MenuEimerGruen")
                    ]
                case "ShangHai": print("ShangHai")
                default: break
                }
            }
        }
    }
}
