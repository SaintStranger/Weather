//
//  AllCitiesCell.swift
//  Weather
//
//  Created by Антон Чечевичкин on 15.10.2020.
//  Copyright © 2020 Антон Чечевичкин. All rights reserved.
//

import UIKit

class AllCitiesCell: UITableViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var cityAvatar: UIImageView!
    
//    func configure (city: String, avatar: UIImage) {
//        self.cityName.text = city
//        self.cityAvatar.image = avatar
//
//        self.backgroundColor = UIColor.blue
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.cityName.text = nil
//        self.cityAvatar.image = nil
//    }
//
//    override func layoutIfNeeded() {
//        super.layoutIfNeeded()
//
//        cityAvatar.clipsToBounds = true
//        cityAvatar.layer.cornerRadius = cityAvatar.frame.width / 2
//
//    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
