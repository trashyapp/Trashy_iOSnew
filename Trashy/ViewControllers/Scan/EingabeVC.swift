//
//  EingabeVC.swift
//  Trashy
//
//  Created by Kai Zheng on 26.06.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import UIKit
import Hero

class EingabeVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    //mit collectionview und suchefeld - materialien werden mit hilfe von bildern und titeln angezeigt
    
    var produktArray = [Produkt]()
    var materialArray = [Material]()
    var materialNameArray = [String]()
    var filteredMaterialNameArray = [String]()
    var barcodeVorhanden = false

    @IBOutlet weak var materialienTableView: UITableView!
    @IBOutlet weak var materialienCollectionView: UICollectionView!
    @IBOutlet weak var materialienSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        self.view.hero.id = "EingabeVCAnimation"
        
        if barcodeVorhanden {
            print("KeinErgebnisVC: " + produktArray[0].barcodeNummer)
            //Dann wird eine view / ein button sichtbar, die fragt, ob man helfen will, das Produkt hinzuzufügen
        } else {
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.getMaterial() { (returnedMaterialArray) in
            self.materialArray = returnedMaterialArray
            
            print(self.materialArray[0].materialBeschreibung)
            
            self.materialienTableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        for i in 0..<materialArray.count {
            materialNameArray.append(materialArray[i].materialName)
        }
        
        filteredMaterialNameArray = searchText.isEmpty ? materialNameArray : materialNameArray.filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        materialienTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.materialienSearchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return materialArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialienCell") as? EingabeVCMaterialienTVCell else {
            return UITableViewCell()
        }

        cell.materialLabel.text = materialArray[indexPath.row].materialName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
