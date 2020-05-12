//
//  NavViewController.swift
//  Spreadly
//
//  Created by Michael Wlodawsky on 5/12/20.
//  Copyright © 2020 Spreadly. All rights reserved.
//

import UIKit

class NavViewController: UINavigationController {
    @IBOutlet weak var NavBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavBar.tintColor = spreadlyGreen
    }
    
}
