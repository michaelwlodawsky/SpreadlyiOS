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

struct cellData {
    var opened = Bool()
    var title = String()
    var data = [MenuItem]()
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var tableViewData = [cellData]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let backButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton
        
        // TODO: Get menu from Firebase
        // Test Code only
        //let item = MenuItem(name: "Test of a long item string?", type: "entree", price: 199.99, description: "I am only a test of a very very very long description thing lets see how long we can make this bitch gooooooooooooo.", ingredients: ["foo", "bar"], sides: ["foo"], pescatarian: false, vegan: true, gf: false, vegetarian: false)
        
        // Get the menu from Firebase
//        let menu: [String: [MenuItem]] = readFirebase()
//        for (key, value) in menu {
//            tableViewData.append(cellData(opened: false, title: key, data: value))
//        }
//        tableView.reloadData()

        //menu.append(item)
        readFirebase()
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("count: \(tableViewData.count)")
        return tableViewData.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened {
            return tableViewData[section].data.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Populate popover with menu shit
        //performSegue(withIdentifier: "menuDetail", sender: self)
        if tableViewData[indexPath.section].opened {
            tableViewData[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            // Do reload here
            tableView.reloadSections(sections, with: .none)
        } else {
            tableViewData[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            // Do reload here
            tableView.reloadSections(sections, with: .automatic)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell")
            
            cell?.textLabel?.text = tableViewData[indexPath.section].title
            
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
            
            let item = tableViewData[indexPath.section].data[indexPath.row - 1]
    
            cell.itemName.text = item.name
            cell.itemPrice.text = String(format: "$%0.2f", item.price)
            cell.itemDescription.text = item.description ?? ""
            cell.itemImage.image = UIImage(named: "Burrito.jpeg")
            
            return cell
        }
    }
    
    // TODO: Make data update in View Table wait for firebase read
    private func readFirebase() {
        print("Reading from Firebase")
        var menu: [String: [MenuItem]] = [:]
        db.collection("clients").document("\(appDelegate.query!)").collection("menu").getDocuments { (snapshot, error) in
            if error != nil {
                print("***Error reading Firebase***")
                print("\(error ?? "No Error?" as! Error)")
            } else {
                for document in snapshot?.documents ?? [] {
                    print("\(document.documentID) : \(document.data())")
                    let data = document.data()
                    // Conform each menu item to Data Structure { type: [MenuItem], type: [MenuItem], ... }
                    let itemType = data["type"] as! String
                    var price: Float = 0.0
                    if let number = data["price"] as? NSNumber {
                        price = number.floatValue
                    }
                    let item = MenuItem(name: document.documentID,
                                        type: itemType,
                                        price: price,
                                        description: data["description", default: ""] as? String,
                                        ingredients: data["ingredients", default: []] as? [String],
                                        sides: data["sides", default: []] as? [String],
                                        pescatarian: data["pescatarian", default: false] as? Bool,
                                        vegan: data["vegan", default: false] as? Bool,
                                        gf: data["gf", default: false] as? Bool,
                                        vegetarian: data["vegetarian", default: false] as? Bool)
                    if menu[itemType] == nil {
                        // Item type exists in datastructure
                        menu[itemType] = [item]
                    } else {
                        // Item type doesn't exist in datastructure
                        menu[itemType]?.append(item)
                    }
                }
                // Reload UI
                for (key, value) in menu {
                    self.tableViewData.append(cellData(opened: false, title: key, data: value))
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func getImage(imagePath: String) -> UIImage {
        // TODO: Get image from Firebase
        return UIImage()
    }

}
