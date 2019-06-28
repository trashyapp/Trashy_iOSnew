//
//  InformationVC.swift
//  Trashy
//
//  Created by Kai Zheng on 28.06.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import UIKit

class InformationVC: UIViewController {

    @IBOutlet weak var tabBarView: RoundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tabBarView.layer.zPosition += 1
        setUpShatten(view: tabBarView, op: 0.5)
    }
    
    func setUpShatten(view: UIView, op: Float) {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = op
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 20
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
