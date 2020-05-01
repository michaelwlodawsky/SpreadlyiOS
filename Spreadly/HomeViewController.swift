//
//  ViewController.swift
//  Spreadly
//
//  Created by Michael Wlodawsky on 4/29/20.
//  Copyright © 2020 Spreadly. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {


    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        //label.text = appDelegate.query
        //readFirebase()
    }
    
    // TODO: Map output of menu to MenuType to be used for populating Menu Table, below works as expected
    func readFirebase() {
        print("HERE?")
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
}

