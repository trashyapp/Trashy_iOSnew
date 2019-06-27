//
//  RoundImageView.swift
//  Trashy
//
//  Created by Kai Zheng on 27.06.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
    }
}
