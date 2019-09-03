//
//  ErgebnisVC.swift
//  Trashy
//
//  Created by Kai Zheng on 25.06.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import UIKit

class ErgebnisVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var produktArray = [Produkt]()
    var materialArray = [Material]()
    var materials = ["r23423423", "r3werwer", "rewrwerwer", "rewrwerwe"]

    @IBOutlet weak var materialienTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("rwerwererwer!" + produktArray[0].barcodeNummer)
        /*
        if produktArray.count != 0 {
            print("ErgebnisVC: " + produktArray[0].barcodeNummer)
            
            for i in 0..<materialArray.count {
                for k in 0..<produktArray[0].produktMaterialien.count {
                    if materialArray[i].materialNummer == produktArray[0].produktMaterialien[k] {
                        materials.append(materialArray[i].materialName)
                    }
                }
            }
        }*/
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return materials.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialienCell") as? EingabeVCMaterialienTVCell else {
            return UITableViewCell()
        }
        
        cell.materialLabel.text = materials[indexPath.row]
        setUpShatten(view: cell.materialShadowView, op: 0.2, radius: 5.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(materials[indexPath.row])
    }
    
    func setUpShatten(view: UIView, op: Float, radius: CGFloat) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = op
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = radius
    }
}
