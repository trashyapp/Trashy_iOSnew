//
//  ScanVC.swift
//  Trashy
//
//  Created by Kai Zheng on 25.06.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import UIKit
import BarcodeScanner

class ScanVC: BarcodeScannerViewController {
    
    var produktArray = [Produkt]()

    @IBOutlet weak var eingabeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.codeDelegate = self as? BarcodeScannerCodeDelegate
        self.errorDelegate = self as? BarcodeScannerErrorDelegate
        self.dismissalDelegate = self as? BarcodeScannerDismissalDelegate
        
        //self.messageViewController.view.isHidden = true
        //self.messageViewController.view.layer.zPosition -= 1
        
        self.eingabeButton.layer.zPosition += 1
    }
    
    @IBAction func eingabeButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toEingabeVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ErgebnisVC {
            let ergebnisVC = segue.destination as? ErgebnisVC
            ergebnisVC?.produktArray = produktArray
        }
    }
}

extension ScanVC: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
        DataService.instance.getProdukt(code: code) { (returnedProduktArray) in
            self.produktArray = returnedProduktArray
            
            DispatchQueue.main.async {
                if self.produktArray.count != 0 {
                    print(self.produktArray)
                    print(self.produktArray[0].barcodeNummer)
                    print(self.produktArray[0])
                    
                    self.performSegue(withIdentifier: "toErgebnisVC", sender: self)
                } else {
                    //PopUp
                    
                    self.performSegue(withIdentifier: "toEingabeVC", sender: self)
                }
            }
        }
    }
}
