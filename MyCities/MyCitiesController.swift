//
//  MyCitiesController.swift
//  Weather
//
//  Created by Антон Чечевичкин on 15.10.2020.
//  Copyright © 2020 Антон Чечевичкин. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import FirebaseDatabase
import FirebaseAuth

class MyCitiesController: UITableViewController {
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let alertVC = UIAlertController(title: "Введите название города", message: nil, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [self] _ in
            guard let textField = alertVC.textFields?.first,
                  let cityName = textField.text else {
                return
            }
            
            let city = FirebaseCity(name: cityName, zipcode: Int.random(in: 100000...999999), weathers: self.cities[0].weathers)
            
            let cityRef = self.ref.child(cityName.lowercased())
            
            cityRef.setValue(city.toAnyObject())
        }
        

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alertVC.addTextField()
        alertVC.addAction(saveAction)
        alertVC.addAction(cancelAction)
        
        
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func logOutButton (_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch (let error) {
            print("Выход из аккаунта не получился: \(error)")
        }
    }
    
//    var cities: Results<City>?
//
//    var token: NotificationToken?
    
    private var cities = [FirebaseCity]()
    
    private let ref = Database.database().reference(withPath: "cities")
    
    let weatherService = WeatherService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ref.observe(.value) { snapshot in
            var cities: [FirebaseCity] = []
            
            if cities.count > 0 {
                saveToFirestore(weathers: cities[0].weathers)
            }
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let city = FirebaseCity(snapshot: snapshot, weathers: Any) {
                    cities.append(city)
                }
            }
            
            self.cities = cities
            self.tableView.reloadData()
        }

//        realmTable()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AllCitiesCell", for: indexPath) as? AllCitiesCell else { return UITableViewCell()
        }
        
        let city = cities[indexPath.row]
        
        cell.cityName.text = city.name

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWeatherViewController",
           let cell = sender as? UITableViewCell {
            let ctrl = segue.destination as! WeatherViewController
            if let indexPath = tableView.indexPath(for: cell) {
                ctrl.cityName = cities[indexPath.row].name
            }
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            let city = cities[indexPath.row]
            city.ref?.removeValue()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation
s
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    func realmTable() {
//        guard let realm = try? Realm() else { return }
//        cities = realm.objects(City.self)
//        token = cities?.observe { [weak self] (changes: RealmCollectionChange) in
//            guard let tableView = self?.tableView else { return }
//            switch changes {
//            case .initial:
//                tableView.reloadData()
//            case .update(_, let deletions, let insertions, let modifications):
//                tableView.beginUpdates()
//                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0)
//                }), with: .automatic)
//                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
//                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
//                tableView.endUpdates()
//            case .error(let error):
//                fatalError("\(error)")
//            }
//        }
//    }
    
//    func showAddCityForm() {
//        let alertController = UIAlertController(title: "Введите название города", message: nil, preferredStyle: .alert)
//
//        alertController.addTextField {(_ textField: UITextField) -> Void in
//        }
//
//        let confirmation = UIAlertAction(title: "Добавить", style: .default) { [weak self] action in
//            guard let name = alertController.textFields?[0].text else { return }
//            self?.addCity(<#Any#>)
//        }
//
//        alertController.addAction(confirmation)
//
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
//
//        present(alertController, animated: true) {}
//    }
    
//    func addCity(_ sender: Any) {
//
//        let alertVC = UIAlertController(title: "Введите название города", message: nil, preferredStyle: .alert)
//
//        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
//            guard let textField = alertVC.textFields?.first,
//                  let cityName = textField.text else {
//                return
//            }
//
//            let city = FirebaseCity(name: cityName, zipcode: Int.random(in: 100000...999999))
//
//            let cityRef = self.ref.child(cityName.lowercased())
//
//            cityRef.setValue(city.toAnyObject())
//        }
//
//
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
//
//        alertVC.addTextField()
//        alertVC.addAction(saveAction)
//        alertVC.addAction(cancelAction)
//
//
//        present(alertVC, animated: true, completion: nil)
        
//        let newCity = City()
//        newCity.name = name
//
//        do {
//            let realm = try Realm()
//            realm.beginWrite()
//            realm.add(newCity)
//            try realm.commitWrite()
//        } catch {
//            print(error)
//        }
//
//    }
    
    
    

}
