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
    
    var item: MenuItem? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        itemDescription.text = item?.description
        itemPrice.text = String(format: "$%0.2f", item!.price)
        itemTitle.text = item?.name
        imageView.image = item?.image
    }

    @IBAction func onExit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
