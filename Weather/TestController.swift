//
//  TestController.swift
//  Weather
//
//  Created by Антон Чечевичкин on 14.10.2020.
//  Copyright © 2020 Антон Чечевичкин. All rights reserved.
//

import UIKit

class TestController: UIViewController {


    @IBOutlet var myTable: UITableView! {
        didSet {
            myTable.delegate = self
            myTable.dataSource = self
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension TestController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFavoriteCell", for: indexPath) as! MyCell
        
        cell.CellTitle.text = "Hello Kitty"
        return cell
    }
    
}


extension TestController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Нажата строка № \(indexPath.row) в секции \(indexPath.section)")
        
    }
    
}
