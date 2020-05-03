//
//  MenuViewController.swift
//  Spreadly
//
//  Created by Michael Wlodawsky on 5/1/20.
//  Copyright © 2020 Spreadly. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var menu: [MenuItem] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let backButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton
        
        // TODO: Get menu from Firebase
        // Test Code only
        let item = MenuItem(name: "Test of a long item string?", type: "entree", price: 199.99, description: "I am only a test of a very very very long description thing lets see how long we can make this bitch gooooooooooooo.", ingredients: ["foo", "bar"], sides: ["foo"], pescatarian: false, vegan: true, gf: false, vegetarian: false)
        menu.append(item)
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuTableViewCell
        let item = menu[indexPath.row]
        
        cell.itemName.text = item.name
        cell.itemPrice.text = String(format: "$%0.2f", item.price)
        cell.itemDescription.text = item.description ?? ""
        cell.itemImage.image = UIImage(named: "Burrito.jpeg")
        
        return cell
    }
    
    // TODO: Map output of menu to MenuItem to be used for populating Menu Table, below works as expected
    func readFirebase() {
        print("Reading from Firebase")
        db.collection("clients").document("\(appDelegate.query!)").collection("menu").getDocuments { (snapshot, error) in
            if error != nil {
                print("***Error reading Firebase***")
                print("\(error ?? "No Error?" as! Error)")
            } else {
                for document in snapshot?.documents ?? [] {
                    print("\(document.data())")
                }
            }
        }
    }
    
    func getImage(imagePath: String) -> UIImage {
        // TODO: Get image from Firebase
        return UIImage()
    }

}
