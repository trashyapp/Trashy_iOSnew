//
//  SucheTVCell.swift
//  Trashy
//
//  Created by Kai Zheng on 02.07.19.
//  Copyright © 2019 Trashy. All rights reserved.
//

import UIKit

class SucheTVCell: UITableViewCell {

    @IBOutlet weak var sucheView: RoundView!
    @IBOutlet weak var sucheImageView: RoundImageView!
    @IBOutlet weak var sucheLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
