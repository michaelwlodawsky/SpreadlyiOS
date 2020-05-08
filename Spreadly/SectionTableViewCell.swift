//
//  SectionTableViewCell.swift
//  Spreadly
//
//  Created by Michael Wlodawsky on 5/8/20.
//  Copyright © 2020 Spreadly. All rights reserved.
//

import UIKit

class SectionTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var accessory: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
