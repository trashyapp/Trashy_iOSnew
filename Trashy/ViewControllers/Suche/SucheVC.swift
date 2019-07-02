//
//  SucheVC.swift
//  Trashy
//
//  Created by Kai Zheng on 02.07.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import UIKit

class SucheVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tabBarView: RoundView!
    @IBOutlet weak var sucheTabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarView.layer.zPosition += 1
        setUpShatten(view: tabBarView, op: 0.5, radius: 20.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.sucheTabelView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    func setUpShatten(view: UIView, op: Float, radius: CGFloat) {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = op
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = radius
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sucheCell = tableView.dequeueReusableCell(withIdentifier: "SucheCell") as! SucheTVCell
        
        setUpShatten(view: sucheCell.sucheView, op: 0.3, radius: 8)
        
        return sucheCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
