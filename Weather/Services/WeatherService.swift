//
//  WeatherService.swift
//  Weather
//
//  Created by Антон Чечевичкин on 25.02.2021.
//  Copyright © 2021 Антон Чечевичкин. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import FirebaseFirestore

class WeatherService {
    
    let baseUrl = "http://api.openweathermap.org"
    
    let apiKey = "92cabe9523da26194b02974bfcd50b7e"
    
    func loadWeatherData(city: String) {
        
        let path = "/data/2.5/forecast"

        let parameters = [
            "q": city,
            "unit": "metric",
            "appId": apiKey
        ]

        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData { response in
        
            guard let data = response.value else { return }
            
            let weather = try! JSONDecoder().decode(WeatherResponse.self, from: data).list
            weather.forEach { $0.city = city }
            saveWeatherData(weather, city: city)
            print(weather)
        }
    }
    
}

func saveWeatherData(_ weathers: [Weather], city: String) {
    do {
        let realm = try Realm()
        guard let city = realm.object(ofType: City.self, forPrimaryKey: city) else { return }
        let oldWeather = city.weathers
        realm.beginWrite()
        realm.delete(oldWeather)
        city.weathers.append(objectsIn: weathers)
        try realm.commitWrite()
        print(realm.configuration.fileURL as Any)
    } catch {
        print(error)
    }
}

func saveToFirestore(weathers: [Weather]) {
    
    let database = Firestore.firestore()
    let settings = database.settings
    database.settings = settings
    
    let weatherToSend = weathers
        .map{ $0.toFirestore() }
        .reduce([:]){$0.merging($1) { (current, _) in current } }
    
    database.collection("forecasts").document("name").setData(weatherToSend, merge: true) {
        error in
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("data saved")
        }
    }
}
