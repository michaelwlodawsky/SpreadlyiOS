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
import FirebaseStorage

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
        
        let dispatchGroup = DispatchGroup()
        
        

        readFirebase() { (menu) -> (Void) in
            print("***menu: \(menu)")
            self.getImages(group: dispatchGroup, menu: menu) { () -> (Void) in
                dispatchGroup.notify(queue: .main) {
                    print("We got all the images")
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
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
            cell.itemImage.image = item.image ?? UIImage(named: "Default.png")
            
            return cell
        }
    }
    
    // TODO: Make data update in View Table wait for firebase read
    private func readFirebase(completion: @escaping ([String: [MenuItem]]) -> (Void)) {
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
                                        imageString: data["image", default: ""] as? String,
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
                completion(menu)
            }
        }
    }
    
    private func getImages(group: DispatchGroup, menu: [String: [MenuItem]], completion: @escaping () -> (Void)) {
        // TODO: Get image from Firebase
        for (key, value) in menu {
            for item in value {
                if item.imageString != nil {
                    group.enter()
                    // TODO: Fix Concurrency issue, setting of data needs to happen after image read
                    let storageRef = Storage.storage().reference(forURL: item.imageString!)
                    storageRef.getData(maxSize: item.MAX_IMAGE_SIZE) { (data, error) in
                        if error != nil {
                            print("Error: Couldn't pull image from Firebase Storage")
                            print("\(error)")
                        } else {
                            print("Downloaded image from Firebase")
                            item.image = UIImage(data: data!)
                        }
                        group.leave()
                        // TODO: add to tableViewData here to fix concurrency issue
                        //self.tableView.reloadData()
                    }

                }
            }
            self.tableViewData.append(cellData(opened: false, title: key, data: value))
        }
        completion()
    }

}
