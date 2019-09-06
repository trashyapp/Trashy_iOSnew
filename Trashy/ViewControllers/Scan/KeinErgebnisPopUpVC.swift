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
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var produktCode: String?

    @IBOutlet weak var mainView: RoundView!
    @IBOutlet weak var kEStackView: UIStackView!
    @IBOutlet weak var eingabeButton: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        self.eingabeButton.hero.id = "KeinErgebnisPopUpVCAnimation"
        mainView.hero.modifiers = [.translate(x: 120)]
        
        setUpShatten(any: mainView, op: 0.3)
        setUpShatten(any: eingabeButton, op: 0.3)
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.01)
        
        print("KeinErgebnisVC: " + produktCode!)
    }
    
    func setUpShatten(any: AnyObject, op: Float) {
        any.layer.shadowColor = UIColor.darkGray.cgColor
        any.layer.shadowOpacity = op
        any.layer.shadowOffset = .zero
        any.layer.shadowRadius = 30
    }
    
    @IBAction func eingabeButtonAction(_ sender: Any) {
        eingabeButton.hero.id = "EingabeVCAnimation"
        toEingabeVC()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        let mainTBC = storyBoard.instantiateViewController(withIdentifier: "MainTBCSB") as! MainTBC
        self.present(mainTBC, animated: true, completion: nil)
    }
    
    func toEingabeVC() {
        let eingabeVC = storyBoard.instantiateViewController(withIdentifier: "EingabeVCSB") as! EingabeVC
        eingabeVC.produktCode = produktCode
        eingabeVC.barcodeVorhanden = true
        
        self.present(eingabeVC, animated: true, completion: nil)
    }
}
