//
//  MyCell.swift
//  Weather
//
//  Created by Антон Чечевичкин on 14.10.2020.
//  Copyright © 2020 Антон Чечевичкин. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {
    
    
    @IBOutlet weak var CellTitle: UILabel!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
