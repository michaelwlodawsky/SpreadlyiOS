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
import CoreData

struct cellData {
    var opened = Bool()
    var title = String()
    var data = [MenuItem]()
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var tableViewData = [cellData]()
    var sectionImage = UIImage(systemName: "chevron.down")
    let veganImage = UIImage(named: "Vegan.png")!
    let vegetarianImage = UIImage(named: "Vegetarian.png")!
    let pescatarianImage = UIImage(named: "Pescatarian.png")!
    let gfImage = UIImage(named: "GF.png")!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        let backButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton
                
        let dispatchGroup = DispatchGroup()

        
        // Firebase work
        self.showLoading(superView: self.view)
        readFirebase() { (menu) -> (Void) in
            self.getImages(group: dispatchGroup, menu: menu) { () -> (Void) in
                dispatchGroup.notify(queue: .main) {
                    self.removeLoading()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Set cell height for sections and rows
        if indexPath.row == 0 {
            return 55
        } else {
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Only open and close sections if selecting the section header
        if indexPath.row == 0 {
            if tableViewData[indexPath.section].opened {
                tableViewData[indexPath.section].opened = false
                self.sectionImage = UIImage(systemName: "chevron.down")
                let sections = IndexSet.init(integer: indexPath.section)
                // Do reload here
                tableView.reloadSections(sections, with: .automatic)
            } else {
                tableViewData[indexPath.section].opened = true
                self.sectionImage = UIImage(systemName: "chevron.right")
                let sections = IndexSet.init(integer: indexPath.section)
                // Do reload here
                tableView.reloadSections(sections, with: .automatic)
            }
        } else {
            // Show detail page
            performSegue(withIdentifier: "menuDetail", sender: self)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell") as! SectionTableViewCell
            cell.title.text = tableViewData[indexPath.section].title
            cell.accessory.image = sectionImage
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
            
            let item = tableViewData[indexPath.section].data[indexPath.row - 1]

            // Setup Dietary images
            
            if item.dietaryImages.indices.contains(0) {
                cell.dietaryImage1.isHidden = false
                cell.dietaryImage1.image = item.dietaryImages[0]
            } else {
                cell.dietaryImage1.isHidden = true
            }
            if item.dietaryImages.indices.contains(1) {
                cell.dietaryImage2.isHidden = false
                cell.dietaryImage2.image = item.dietaryImages[1]
            } else {
                cell.dietaryImage2.isHidden = true
            }
            if item.dietaryImages.indices.contains(2) {
                cell.dietaryImage3.isHidden = false
                cell.dietaryImage3.image = item.dietaryImages[2]
            } else {
                cell.dietaryImage3.isHidden = true
            }
            
            
    
            cell.itemName.text = item.name
            cell.itemPrice.text = item.price
            cell.itemDescription.text = item.description ?? ""
            cell.itemImage.image = item.image ?? UIImage(named: "Default.png")
            
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? MenuDetailsViewController {
            guard let index = tableView.indexPathForSelectedRow?.section else {
                return
            }
            guard let dataIndex = tableView.indexPathForSelectedRow?.row else {
                return
            }
            let item = tableViewData[index].data[dataIndex - 1]
            destinationVC.item = item
        }
    }

    
    private func readFirebase(completion: @escaping ([String: [MenuItem]]) -> (Void)) {
        print("Reading from Firebase")
        var menu: [String: [MenuItem]] = [:]
        db.collection("clients").document("\(appDelegate.query!)").collection("menu").getDocuments { (snapshot, error) in
            if error != nil {
                print("***Error reading Firebase***")
                print("\(error ?? "No Error?" as! Error)")
            } else {
                for document in snapshot?.documents ?? [] {
                    let data = document.data()
                    // Conform each menu item to Data Structure { type: [MenuItem], type: [MenuItem], ... }
                    let itemType = data["type"] as! String
                    
                    let item = MenuItem(name: document.documentID,
                                        type: itemType,
                                        price: data["price"] as! String,
                                        imageString: data["image", default: ""] as? String,
                                        description: data["description", default: ""] as? String,
                                        ingredients: data["ingredients", default: []] as? [String],
                                        sides: data["sides", default: []] as? [String],
                                        pescatarian: data["pescatarian", default: false] as? Bool,
                                        vegan: data["vegan", default: false] as? Bool,
                                        gf: data["gf", default: false] as? Bool,
                                        vegetarian: data["vegetarian", default: false] as? Bool)
                    // Setup Dietary Images
                    if item.vegetarian ?? false && !(item.vegan ?? false) {
                        item.dietaryImages.append(self.vegetarianImage)
                    } else if !(item.vegetarian ?? false) && item.vegan ?? false {
                        item.dietaryImages.append(self.veganImage)
                    }
                    if item.gf ?? false {
                        item.dietaryImages.append(self.gfImage)
                    }
                    if item.pescatarian ?? false {
                        item.dietaryImages.append(self.pescatarianImage)
                    }
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
        for (key, value) in menu {
            for item in value {
                if item.imageString != nil {
                    group.enter()
                    let storageRef = Storage.storage().reference(forURL: item.imageString!)
                    storageRef.getData(maxSize: item.MAX_IMAGE_SIZE) { (data, error) in
                        if error != nil {
                            print("Error: Couldn't pull image from Firebase Storage")
                            print("\(error ?? "No Error?" as! Error)")
                        } else {
                            item.image = UIImage(data: data!)
                        }
                        group.leave()
                    }
                }
            }
            self.tableViewData.append(cellData(opened: false, title: key, data: value))
        }
        completion()
    }

}
