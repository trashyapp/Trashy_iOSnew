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

class ScanVC: BarcodeScannerViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var produktArray = [Produkt]()
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var trashImageArray = ["TrashBlau", "TrashGrau", "TrashBraun", "TrashGelb"]
    
    @IBOutlet weak var tabBarView: RoundView!
    @IBOutlet weak var scanCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.codeDelegate = self as? BarcodeScannerCodeDelegate
        self.errorDelegate = self as? BarcodeScannerErrorDelegate
        self.dismissalDelegate = self as? BarcodeScannerDismissalDelegate
        
        self.messageViewController.textLabel.hero.id = "KeinErgebnisPopUpVCAnimation"
        
        scanCollectionView.layer.zPosition += 1
        tabBarView.layer.zPosition += 1
        
        setUpShatten(view: tabBarView, op: 0.5)
        
        setUpEingabeButton()
    }
    
    func setUpShatten(view: UIView, op: Float) {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = op
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 20
    }
    
    func setUpEingabeButton() {
        let eingabeButtonImage = UIImage(named: "EingabeSymbol") as UIImage?
        
        let eingabeButton = RoundButton()
        eingabeButton.layer.cornerRadius = 10
        //eingabeButton.backgroundColor = UIColor.init(named: "TrashyBlue")
        eingabeButton.addTarget(self, action: #selector(eingabeButtonAction), for: .touchUpInside)
        eingabeButton.translatesAutoresizingMaskIntoConstraints = false
        eingabeButton.setImage(eingabeButtonImage, for: .normal)
        
        self.cameraViewController.view.addSubview(eingabeButton)
        
        eingabeButton.widthAnchor.constraint(equalToConstant: 65).isActive = true
        eingabeButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        let margins = view.layoutMarginsGuide
        eingabeButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 3).isActive = true
        eingabeButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -155).isActive = true
        
        eingabeButton.hero.id = "EingabeVCAnimation"
    }
    
    @objc func eingabeButtonAction(sender: UIButton!) {
        toEingabeVC()
    }
    
    func toEingabeVC() {
        let eingabeVC = storyBoard.instantiateViewController(withIdentifier: "EingabeVCSB") as! EingabeVC
        eingabeVC.produktArray = produktArray
        
        self.present(eingabeVC, animated: true, completion: nil)
    }
    
    func toKeinErgebnisPopUpVC() {
        let keinErgebnisPopUpVC = storyBoard.instantiateViewController(withIdentifier: "KeinErgebnisPopUpVCSB") as! KeinErgebnisPopUpVC
        keinErgebnisPopUpVC.modalPresentationStyle = .overFullScreen
        keinErgebnisPopUpVC.produktArray = produktArray
        
        self.present(keinErgebnisPopUpVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trashImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let trashCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrashCell", for: indexPath) as! TrashCVCell
        
        trashCell.trashImageView.image = UIImage.init(named: trashImageArray[indexPath.row])
        
        return trashCell
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
        print("ScanVC1: " + code)
        
        DataService.instance.getProdukt(code: code) { (returnedProduktArray) in
            self.produktArray = returnedProduktArray
            
            DispatchQueue.main.async {
                if self.produktArray[0].produktNummer != -1 {
                    print("ScanVC2: " + self.produktArray[0].barcodeNummer)
                    
                    self.performSegue(withIdentifier: "toErgebnisVC", sender: self)
                } else {
                    print("ScanVC3: " + self.produktArray[0].barcodeNummer)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.toKeinErgebnisPopUpVC()
                    }
                }
            }
        }
    }
}
