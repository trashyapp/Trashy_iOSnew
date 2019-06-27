//
//  EingabeVC.swift
//  Trashy
//
//  Created by Kai Zheng on 26.06.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import UIKit
import Hero

class EingabeVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    //mit collectionview und suchefeld - materialien werden mit hilfe von bildern und titeln angezeigt
    
    var produktArray = [Produkt]()
    var materialArray = [Material]()
    var materialNameArray = [String]()
    var currentMaterialNameArray = [String]()
    var barcodeVorhanden = false
    var searchActive = false
    var selectedMaterialArray = [String]()
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    @IBOutlet weak var materialienTableView: UITableView!
    @IBOutlet weak var materialienCollectionView: UICollectionView!
    @IBOutlet weak var materialienSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
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
            
            for i in 0..<self.materialArray.count {
                self.materialNameArray.append(self.materialArray[i].materialName)
            }
            
            self.currentMaterialNameArray = self.materialNameArray
            
            self.materialienTableView.reloadData()
        }
    }
    
    //SearchBar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentMaterialNameArray = materialNameArray
            self.materialienTableView.reloadData()
            return
        }
        currentMaterialNameArray = materialNameArray.filter({ material -> Bool in
            material.lowercased().contains(searchText.lowercased())
        })
        
        if currentMaterialNameArray.count == 0 {
            searchActive = false
        } else {
            searchActive = true
        }
        self.materialienTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    //TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMaterialNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MaterialienCell") as? EingabeVCMaterialienTVCell else {
            return UITableViewCell()
        }

        cell.materialLabel.text = currentMaterialNameArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMaterialArray.append(currentMaterialNameArray[indexPath.row])
        currentMaterialNameArray = materialNameArray
        
        //Auto scroll
        for i in 0..<selectedMaterialArray.count {
            if selectedMaterialArray[i] == currentMaterialNameArray[indexPath.row] {
                let indexPathCV = IndexPath(item: i, section: 0)
                self.materialienCollectionView.scrollToItem(at: indexPathCV, at: [.centeredVertically, .centeredHorizontally], animated: true)
                //self.materialienCollectionView.reloadItems(at: [indexPathCV])
            }
        }
        materialienCollectionView.reloadData()
        materialienTableView.reloadData()
        materialienSearchBar.text = ""
    }
    
    //CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedMaterialArray.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == selectedMaterialArray.count {
            let bestaetigenCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestaetigenCell", for: indexPath) as! EingabeErgebnisButtonCVCell
            
            bestaetigenCell.bestaetigenButton.setTitle("Fertig", for: .normal)
            
            return bestaetigenCell
        }
        let materialCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedMaterialCell", for: indexPath) as! EingabeErgebnisCVCell
        
        if indexPath.row == selectedMaterialArray.count-1 {
            print(selectedMaterialArray[indexPath.row])
            materialCell.selectedMaterialLabel.text = selectedMaterialArray[indexPath.row]
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.materialienCollectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
            }
        }
        return materialCell
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        let mainNVC = storyBoard.instantiateViewController(withIdentifier: "MainNVCSB") as! MainNVC
        
        self.present(mainNVC, animated: true, completion: nil)
    }
}
