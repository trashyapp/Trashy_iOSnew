//
//  MenuVC.swift
//  Trashy
//
//  Created by Kai Zheng on 28.06.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var menu: MenuData!
    var menuDataArray = [Menu]()
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var tabBarView: RoundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menu = MenuData()
        menuDataArray = menu.menuDataArray
        
        tabBarView.layer.zPosition += 1
        setUpShatten(view: tabBarView, op: 0.5, radius: 20.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.menuTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    func setUpShatten(view: UIView, op: Float, radius: CGFloat) {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = op
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = radius
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuVCTVCell
        
        menuCell.menuImageView.image = UIImage.init(named: menuDataArray[indexPath.row].menuImage)
        menuCell.menuLabel.text = menuDataArray[indexPath.row].menuText
        
        setUpShatten(view: menuCell.menuShadowView, op: 0.3, radius: 8)
        
        return menuCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
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
