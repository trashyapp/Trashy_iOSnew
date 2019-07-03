//
//  Menu.swift
//  Trashy
//
//  Created by Kai Zheng on 03.07.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import Foundation

struct Menu {
    private var _menuPoint: String
    private var _menuText: String
    private var _menuImage: String
    
    init(menuPoint: String, menuText: String, menuImage: String) {
        self._menuPoint = menuPoint
        self._menuText = menuText
        self._menuImage = menuImage
    }
    
    var menuPoint: String {
        return _menuPoint
    }
    
    var menuText: String {
        return _menuText
    }
    
    var menuImage: String {
        return _menuImage
    }
}

struct MenuData {
    var menuDataArray = [
        Menu(menuPoint: "Settings", menuText: "Einstellungen", menuImage: "MenuEinstellungen"),
        Menu(menuPoint: "Trashy", menuText: "Trashy", menuImage: "MenuTrashy"),
        Menu(menuPoint: "AboutUs", menuText: "Über Uns", menuImage: "MenuUeberUns"),
        Menu(menuPoint: "TrashYellow", menuText: "Wert-Stoffe", menuImage: "MenuEimerGelb"),
        Menu(menuPoint: "TrashBlue", menuText: "Papier", menuImage: "MenuEimerBlau"),
        Menu(menuPoint: "TrashGray", menuText: "Rest-Stoffe", menuImage: "MenuEimerGrau"),
        Menu(menuPoint: "TrashBrown", menuText: "Bio-Müll", menuImage: "MenuEimerBraun"),
        Menu(menuPoint: "TrashGreen", menuText: "Glas", menuImage: "MenuEimerGruen")
    ]
}
