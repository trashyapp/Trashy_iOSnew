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
    var trash: TrashData!
    var trashDataArray = [Trash]()
    var code = false
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    @IBOutlet weak var tabBarView: RoundView!
    @IBOutlet weak var scanCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trash = TrashData()
        trashDataArray = trash.trashDataArray
        
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
        return trashDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let trashCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrashCell", for: indexPath) as! TrashCVCell
        
        trashCell.trashImageView.image = UIImage.init(named: trashDataArray[indexPath.row].trashImage)
        
        if trashDataArray[indexPath.row].trashNumber == 2 && code {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let trashAnimationVC = storyBoard.instantiateViewController(withIdentifier: "TrashAnimationVCSB") as! TrashAnimationVC
            
            trashAnimationVC.produktArray = self.produktArray
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                trashCell.trashImageView.hero.id = "trashAnimation"
                
                trashAnimationVC.modalPresentationStyle = .overFullScreen
                
                self.present(trashAnimationVC, animated: true, completion: nil)
            }
        }
        
        return trashCell
    }
}

extension ScanVC: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("ScanVC1: " + code)
        
        
        DataService.instance.getSelectedData(code: code) { (returnedSelectedDataArray) in
            print(returnedSelectedDataArray)
            
            self.produktArray = returnedSelectedDataArray[0] as! [Produkt]
            print("ScanVC2: " + self.produktArray[0].barcodeNummer)
        }
        
        /*
        DataService.instance.getProdukt(code: code) { (returnedProduktArray) in
            self.produktArray = returnedProduktArray
            
            print(self.produktArray)
            print(returnedProduktArray)
            
            DispatchQueue.main.async {
                if self.produktArray.count != 0 {
                    print("ScanVC2: " + self.produktArray[0].barcodeNummer)
                    
                    self.code = true
                    self.scanCollectionView.reloadData()
                } else {
                    print("ScanVC3: " + self.produktArray[0].barcodeNummer)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.toKeinErgebnisPopUpVC()
                    }
                }
            }
        }*/
    }
}
