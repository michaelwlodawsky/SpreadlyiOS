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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        let bottomColor = UIColor(red: 60.0 / 255.0, green: 198.0 / 255.0, blue: 132.0 / 255.0, alpha: 1.0).cgColor
        let topColor = UIColor(red: 167.0 / 255.0, green: 221.0 / 255.0, blue: 167.0 / 255.0, alpha: 1.0).cgColor
        
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.frame
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
}

