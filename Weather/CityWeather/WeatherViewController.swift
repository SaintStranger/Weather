//
//  WeatherViewController.swift
//  Weather
//
//  Created by Антон Чечевичкин on 15.10.2020.
//  Copyright © 2020 Антон Чечевичкин. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseFirestore

class WeatherViewController: UIViewController {
    
    var weathers: List<Weather>!
    
    var cityName = ""

    let weatherService = WeatherService()

    let dateFormatter = DateFormatter()
    
    var token: NotificationToken?
    
    @IBOutlet weak var weatherCollectionView: WeatherCollectionView!
    
    @IBOutlet weak var weekDayChooser: WeekDayChooser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        
        weatherService.loadWeatherData(city: cityName)
        
        loadFromRealm()
        
    }


}



extension WeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        
        cell.configure(withWeather: weathers[indexPath.row])
        
        return cell
        
    }
    
    
    func loadFromRealm() {
        guard let realm = try? Realm(),
              let city = realm.object(ofType: City.self, forPrimaryKey: cityName) else { return }
        
        weathers = city.weathers
        
        token = weathers.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.weatherCollectionView else { return }
            
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map( {IndexPath(row: $0, section: 0)} ))
                }, completion: nil)
                collectionView.deleteItems(at: deletions.map( {IndexPath(row: $0, section: 0)} ))
                collectionView.reloadItems(at: modifications.map({IndexPath(row: $0, section: 0)}))
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
}

extension WeatherViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}


