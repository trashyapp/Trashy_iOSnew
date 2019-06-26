//
//  ScanVC.swift
//  Trashy
//
//  Created by Kai Zheng on 25.06.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import UIKit
import BarcodeScanner
import Hero

class ScanVC: BarcodeScannerViewController {
    
    var produktArray = [Produkt]()
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.codeDelegate = self as? BarcodeScannerCodeDelegate
        self.errorDelegate = self as? BarcodeScannerErrorDelegate
        self.dismissalDelegate = self as? BarcodeScannerDismissalDelegate
        
        self.messageViewController.textLabel.hero.id = "KeinErgebnisPopUpVCAnimation"
        
        setUpEingabeButton()
    }
    
    func setUpEingabeButton() {
        let eingabeButton = UIButton()
        eingabeButton.backgroundColor = .white
        eingabeButton.addTarget(self, action: #selector(eingabeButtonAction), for: .touchUpInside)
        eingabeButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.cameraViewController.view.addSubview(eingabeButton)
        
        eingabeButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        eingabeButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        let margins = view.layoutMarginsGuide
        eingabeButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 3).isActive = true
        eingabeButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -30).isActive = true
        
        eingabeButton.hero.id = "EingabeVCAnimation"
    }
    
    @objc func eingabeButtonAction(sender: UIButton!) {
        toEingabeVC()
    }
    
    func toEingabeVC() {
        let eingabeVC = storyBoard.instantiateViewController(withIdentifier: "EingabeVCSB") as! EingabeVC
        
        self.present(eingabeVC, animated: true, completion: nil)
    }
    
    func toKeinErgebnisPopUpVC() {
        let keinErgebnisPopUpVC = storyBoard.instantiateViewController(withIdentifier: "KeinErgebnisPopUpVCSB") as! KeinErgebnisPopUpVC
        keinErgebnisPopUpVC.modalPresentationStyle = .overFullScreen
        
        self.present(keinErgebnisPopUpVC, animated: true, completion: nil)
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
                    self.toKeinErgebnisPopUpVC()
                }
            }
        }
    }
}
