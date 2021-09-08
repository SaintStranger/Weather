//
//  MyCitiesCell.swift
//  Weather
//
//  Created by Антон Чечевичкин on 15.10.2020.
//  Copyright © 2020 Антон Чечевичкин. All rights reserved.
//

import UIKit

class MyCitiesCell: UITableViewCell {
    
    
    @IBOutlet weak var MyCitiesName: UILabel!
    
    
    @IBOutlet weak var myCityAvatar: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
