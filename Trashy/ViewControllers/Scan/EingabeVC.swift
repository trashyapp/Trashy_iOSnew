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
    var longPressedEnabled = false
    
    @IBOutlet weak var materialienTableView: UITableView!
    @IBOutlet weak var materialienCollectionView: UICollectionView!
    @IBOutlet weak var materialienSearchBar: UISearchBar!
    @IBOutlet weak var materialienView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        deletionDone()
        
        //Hero
        self.hero.isEnabled = true
        self.view.hero.id = "EingabeVCAnimation"
        
        setUpShatten(view: materialienView, op: 0.5, radius: 20.0)
   
        materialienCollectionView.layer.zPosition += 1
        
        //Case: Wenn User von KeinErgebnisPopUpVC kommt, also ein Barcode hat, welcher nicht in der DB ist
        if barcodeVorhanden {
            print("KeinErgebnisVC: " + produktArray[0].barcodeNummer)
            //Dann wird eine view / ein button sichtbar, die fragt, ob man helfen will, das Produkt hinzuzufügen
        }
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
        materialienCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    func deletionDone() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EingabeVC.dismissWiggle))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissWiggle() {
        longPressedEnabled = false
        
        self.materialienCollectionView.reloadData()
    }
    
    @objc func longTap(_ gesture: UIGestureRecognizer){
        
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = materialienCollectionView.indexPathForItem(at: gesture.location(in: materialienCollectionView)) else {
                return
            }
            materialienCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            materialienCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            materialienCollectionView.endInteractiveMovement()
            longPressedEnabled = true
            self.materialienCollectionView.reloadData()
        default:
            materialienCollectionView.cancelInteractiveMovement()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //DataService Verbindung herstellen
        
        DataService.instance.getMaterial(materials: [-1]) { (returnedMaterialArray) in
            self.produktArray.removeAll()
            self.materialArray.removeAll()
            
            self.materialArray = returnedMaterialArray
            
            print(self.materialArray[0].materialBeschreibung)
            self.materialNameArray.removeAll()
            self.currentMaterialNameArray.removeAll()
            
            //Materialiennamen in ein einzelnes Array packen
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
        setUpShatten(view: cell.materialShadowView, op: 0.2, radius: 5.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMaterialArray.append(currentMaterialNameArray[indexPath.row])
        
        //Auto scroll
        for i in 0..<selectedMaterialArray.count {
            if selectedMaterialArray[i] == currentMaterialNameArray[indexPath.row] {
                let indexPathCV = IndexPath(item: i, section: 0)
                self.materialienCollectionView.scrollToItem(at: indexPathCV, at: [.centeredVertically, .centeredHorizontally], animated: true)
                //self.materialienCollectionView.reloadItems(at: [indexPathCV])
            }
        }
        
        //Zu dem normalen Zustand zurücksetzen (TableView, SearchBar)
        materialienSearchBar.text = ""
        
        for k in 0..<materialNameArray.count {
            print(materialNameArray.count)
            print(k)
            if currentMaterialNameArray[indexPath.row] == materialNameArray[k] {
                self.materialNameArray.remove(at: k)
                currentMaterialNameArray = materialNameArray
                break
            }
        }
        
        //Änderungen sichtbar machen
        materialienCollectionView.reloadData()
        materialienTableView.reloadData()
        
        materialienTableView.layoutIfNeeded()
        materialienTableView.setContentOffset(.zero, animated: true)
    }
    
    //CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedMaterialArray.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Bestätigungsbutton initialisieren (Sichtbar machen)
        if indexPath.row == selectedMaterialArray.count {
            let bestaetigenCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BestaetigenCell", for: indexPath) as! EingabeErgebnisButtonCVCell
            
            bestaetigenCell.bestaetigenButton.setTitle("Fertig", for: .normal)
            
            //self.materialienCollectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .centeredHorizontally], animated: true)
            
            return bestaetigenCell
        }
        
        //Die ausgewählten Materialien
        let materialCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedMaterialCell", for: indexPath) as! EingabeErgebnisCVCell
        
        materialCell.selectedMaterialDeleteButton.addTarget(self, action: #selector(selectedMaterialDeleteButtonAction(_:)), for: .touchUpInside)
        
        if longPressedEnabled   {
            materialCell.startAnimate()
        }else{
            materialCell.stopAnimate()
        }
        
        //Neu ausgewählte Materialien initialieren (Sichtbar machen)
        print(selectedMaterialArray[indexPath.row])
        print(selectedMaterialArray)
        materialCell.selectedMaterialLabel.text = selectedMaterialArray[indexPath.row]
        
        return materialCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width/4 - 20, height: UIScreen.main.bounds.size.width/4 - 20)
    }
    
    @objc func selectedMaterialDeleteButtonAction(_ sender: AnyObject) {
        let hitPoint = (sender).convert(CGPoint.zero, to: self.materialienCollectionView)
        let hitIndex = self.materialienCollectionView.indexPathForItem(at: hitPoint)
        
        //remove the image and refresh the collection view
        self.materialNameArray.append(selectedMaterialArray[(hitIndex?.row)!])
        self.selectedMaterialArray.remove(at: (hitIndex?.row)!)
        currentMaterialNameArray = materialNameArray
        self.materialienCollectionView.reloadData()
        self.materialienTableView.reloadData()
    }
    
    func setUpShatten(view: UIView, op: Float, radius: CGFloat) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = op
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = radius
    }

    //X-Button rechts-oben: Schließt EingabeVC und geht zu MainNVC - (Abbrechen)
    @IBAction func cancelButton(_ sender: Any) {
        let mainTBC = storyBoard.instantiateViewController(withIdentifier: "MainTBCSB") as! MainTBC
        self.present(mainTBC, animated: true, completion: nil)
    }
}

/*extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}*/


