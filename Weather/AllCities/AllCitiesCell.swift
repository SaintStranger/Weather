//
//  AllCitiesCell.swift
//  Weather
//
//  Created by Антон Чечевичкин on 14.10.2020.
//  Copyright © 2020 Антон Чечевичкин. All rights reserved.
//

import UIKit

class AllCitiesCell: UITableViewCell {
    
    
    @IBOutlet weak var cityName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
