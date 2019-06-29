//
//  MenuVCTVCell.swift
//  Trashy
//
//  Created by Kai Zheng on 29.06.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import UIKit

class MenuVCTVCell: UITableViewCell {

    @IBOutlet weak var menuImageView: RoundImageView!
    @IBOutlet weak var menuShadowView: RoundView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
