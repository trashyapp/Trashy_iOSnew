//
//  SettingsTVC.swift
//  
//
//  Created by Kai Zheng on 04.07.19.
//

import UIKit

class SettingsTVC: UITableViewController {

    @IBOutlet var settingsShadowViews: [RoundView]!
    var selection: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.shadowImage = UIImage()
        
        for i in 0..<settingsShadowViews.count {
            setUpShatten(view: settingsShadowViews[i], op: 0.2, radius: 8.0)
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func setUpShatten(view: UIView, op: Float, radius: CGFloat) {
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = op
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = radius
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("Notification")
        case 1:
            print("Place")
            selection = "Place"
            performSegue(withIdentifier: "toSettingsSelectionTVC", sender: self)
        case 2:
            print("Language")
            selection = "Language"
            performSegue(withIdentifier: "toSettingsSelectionTVC", sender: self)
        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SettingsSelectionTVC {
            let settingsSelectionTVC = segue.destination as? SettingsSelectionTVC
            
            settingsSelectionTVC?.selection = selection
        }
    }
}
