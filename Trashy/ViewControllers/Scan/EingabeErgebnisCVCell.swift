//
//  EingabeErgebnisCVCell.swift
//  Trashy
//
//  Created by Kai Zheng on 27.06.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import UIKit

class EingabeErgebnisCVCell: UICollectionViewCell {
    
    @IBOutlet weak var selectedMaterialImageView: UIImageView!
    @IBOutlet weak var selectedMaterialLabel: UILabel!
    @IBOutlet weak var selectedMaterialDeleteButton: UIButton!
    
    var isAnimate: Bool! = true
    
    //Animation of image
    func startAnimate() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 4
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.2
        shakeAnimation.repeatCount = 99999
        
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.timeOffset = 290 * drand48()
        
        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"animate")
        selectedMaterialDeleteButton.isHidden = false
        isAnimate = true
    }
    
    func stopAnimate() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "animate")
        self.selectedMaterialDeleteButton.isHidden = true
        isAnimate = false
    }
}
