//
//  Design.swift
//  Spreadly
//
//  Created by Michael Wlodawsky on 5/12/20.
//  Copyright © 2020 Spreadly. All rights reserved.
//

import Foundation
import UIKit

let spreadlyGreen = UIColor(red: 45, green: 140, blue: 89, alpha: 1)

var sView: UIView?

extension UIViewController {
    
    func showLoading(superView: UIView) {
        let spinnerView = UIView.init(frame: superView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let spinner = UIActivityIndicatorView.init(style: .medium)
        spinner.startAnimating()
        spinner.center = spinnerView.center
        // TODO: Cuzomize Loading Screen
//        let label = UILabel()
//        label.center = CGPoint(x: spinner.center.x, y: spinner.center.y - 30)
//        label.textColor = .white
//        label.text = "Grabbing your menu!"
//        label.sizeToFit()
//        label.frame.size.height = 30
//        superView.addSubview(label)
        
        DispatchQueue.main.async {
            spinnerView.addSubview(spinner)
            superView.addSubview(spinnerView)
        }
        
        sView = spinnerView
    }
    
    func removeLoading() {
        DispatchQueue.main.async {
            sView?.removeFromSuperview()
            sView = nil
        }
    }
}
