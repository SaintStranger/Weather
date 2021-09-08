//
//  WeatherCell.swift
//  Weather
//
//  Created by Антон Чечевичкин on 15.10.2020.
//  Copyright © 2020 Антон Чечевичкин. All rights reserved.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var weather: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var shadowView: UIView! {
        didSet {
            self.shadowView.layer.shadowOffset = .zero
            self.shadowView.layer.shadowOpacity = 0.77
            self.shadowView.layer.shadowRadius = 6
            self.shadowView.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            self.containerView.clipsToBounds = true
        }
    }

    
    
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy HH.mm"
        return df
    }()
    
    func configure(withWeather weather: Weather) {
        let date = Date(timeIntervalSince1970: weather.date)
        let stringDate = WeatherCell.dateFormatter.string(from: date)
        
        self.weather.text = String(weather.temp)
        time.text = stringDate
        icon.image = UIImage(named: weather.weatherIcon)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.shadowView.layer.shadowPath = UIBezierPath(ovalIn: self.shadowView.bounds).cgPath
        self.shadowView.layer.cornerRadius = self.containerView.frame.width / 2
        self.containerView.layer.cornerRadius = self.containerView.frame.width / 2
    }
    
}
