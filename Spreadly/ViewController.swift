//
//  ViewController.swift
//  Spreadly
//
//  Created by Michael Wlodawsky on 4/29/20.
//  Copyright © 2020 Spreadly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        label.text = appDelegate.query
    }

    func readFirebase() {
        print("HERE?")
        db.collection("clients").document("\(appDelegate.query)").getDocument { (snapshot, error) in
            if error != nil {
                print("***Error reading from firebase***")
                print("\(error)")
            } else {
                print("HM?")
                print("\(snapshot?.get("name"))")
            }
        }
    }
}

