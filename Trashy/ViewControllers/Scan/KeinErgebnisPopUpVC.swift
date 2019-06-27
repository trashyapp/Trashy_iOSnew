//
//  KeinErgebnisPopUpVC.swift
//  Trashy
//
//  Created by Kai Zheng on 26.06.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import UIKit
import Hero

class KeinErgebnisPopUpVC: UIViewController {
    
    var produktArray = [Produkt]()
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    @IBOutlet weak var titleView: RoundView!
    @IBOutlet weak var mainView: RoundView!
    @IBOutlet weak var eingabeButton: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        self.titleView.hero.id = "KeinErgebnisPopUpVCAnimation"
        mainView.hero.modifiers = [.translate(x: -120)]
        eingabeButton.hero.modifiers = [.translate(x: -120)]
        
        eingabeButton.hero.id = "EingabeVCAnimation"
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.10)
        setUpShatten(view: mainView, op: 0.75)
        setUpShatten(view: titleView, op: 1.0)
        
        print("KeinErgebnisVC: " + produktArray[0].barcodeNummer)
    }
    
    func setUpShatten(view: UIView, op: Float) {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = op
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
    }
    
    @IBAction func eingabeButtonAction(_ sender: Any) {
        toEingabeVC()
    }
    
    func toEingabeVC() {
        let eingabeVC = storyBoard.instantiateViewController(withIdentifier: "EingabeVCSB") as! EingabeVC
        eingabeVC.produktArray = produktArray
        eingabeVC.barcodeVorhanden = true
        
        self.present(eingabeVC, animated: true, completion: nil)
    }
}
