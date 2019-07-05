//
//  SettingsSelectionTVC.swift
//  Trashy
//
//  Created by Kai Zheng on 04.07.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import UIKit

class SettingsSelectionTVC: UITableViewController {
    
    var selection: String!
    var selectionArray = [String]()
    var place: PlaceData!
    var places = [Place]()

    @IBOutlet var selectionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch selection {
        case "Place":
            place = PlaceData()
            places = place.places
            for i in 0..<places.count {
                selectionArray.append(places[i].place)
                selectionTableView.reloadData()
            }
        case "Language":
            print("Language")
        default: break
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.selectionTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    func setUpShatten(view: UIView, op: Float, radius: CGFloat) {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = op
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = radius
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return selectionArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let selectionCell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell") as? SettingsSelectionTVCell else {
            return UITableViewCell()
        }
        
        setUpShatten(view: selectionCell.selectionView, op: 0.2, radius: 5.0)
        
        selectionCell.selectionLabel.text = selectionArray[indexPath.row]
        
        return selectionCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
