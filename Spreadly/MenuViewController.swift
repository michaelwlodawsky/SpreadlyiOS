//
//  MenuViewController.swift
//  Spreadly
//
//  Created by Michael Wlodawsky on 5/1/20.
//  Copyright © 2020 Spreadly. All rights reserved.
//

import UIKit
import AVFoundation

class MenuViewController: UIViewController {
    
    var captureSession: AVCaptureSession? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    

}
