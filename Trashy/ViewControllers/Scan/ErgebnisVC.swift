//
//  ErgebnisVC.swift
//  Trashy
//
//  Created by Kai Zheng on 25.06.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import UIKit

class ErgebnisVC: UIViewController {
    
    var produktArray = [Produkt]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ErgebnisVC: " + produktArray[0].barcodeNummer)
    }
    
    /*override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }*/
}
