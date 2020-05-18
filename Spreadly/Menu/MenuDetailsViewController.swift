//
//  MenuDetailsViewController.swift
//  Spreadly
//
//  Created by Michael Wlodawsky on 5/1/20.
//  Copyright © 2020 Spreadly. All rights reserved.
//

import UIKit

class MenuDetailsViewController: UIViewController {

    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var veggieStackView: UIStackView!
    @IBOutlet weak var pescatarianStackView: UIStackView!
    @IBOutlet weak var gfStackView: UIStackView!
    @IBOutlet weak var veggieImage: UIImageView!
    @IBOutlet weak var veggieLabel: UILabel!
    
    var item: MenuItem? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        itemDescription.text = item?.description
        itemPrice.text = String(format: "$%0.2f", item!.price)
        itemTitle.text = item?.name
        imageView.image = item?.image ?? UIImage(named: "Default.png")
        
        if item?.vegan ?? false {
            veggieImage.image = UIImage(named: "Vegan.png")
            veggieLabel.text = "Vegan"
        }
        if item?.vegan ?? false || item?.vegetarian ?? false {
            veggieStackView.isHidden = false
        }
        if item?.pescatarian ?? false {
            pescatarianStackView.isHidden = false
        }
        if item?.gf ?? false {
            gfStackView.isHidden = false
        }
    }

    @IBAction func onExit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
