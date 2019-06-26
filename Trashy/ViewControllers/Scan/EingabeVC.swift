//
//  EingabeVC.swift
//  Trashy
//
//  Created by Kai Zheng on 26.06.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import UIKit
import Hero

class EingabeVC: UIViewController {
    
    var produktArray = [Produkt]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        self.view.hero.id = "EingabeVCAnimation"

        print("KeinErgebnisVC: " + produktArray[0].barcodeNummer)
    }
}
