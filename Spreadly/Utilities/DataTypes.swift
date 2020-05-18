//
//  DataTypes.swift
//  Spreadly
//
//  Created by Michael Wlodawsky on 5/2/20.
//  Copyright © 2020 Spreadly. All rights reserved.
//

import Foundation
import UIKit

struct DietaryDetail {
    let VEGAN: Int = 0
    let VEGATARIAN: Int = 1
    let PESCATARIAN: Int = 2
    let GLUTEN_FREE: Int = 3
    
    let imageArray: [UIImage?] = [
        UIImage(named: "Vegan.png"),
        UIImage(named: "Vegetarian.png"),
        UIImage(named: "Pescatarian.png"),
        UIImage(named: "GF.png")
    ]
    
}

class MenuItem {
    let MAX_IMAGE_SIZE: Int64 = 1 * 1024 * 1024 //1 MB
    
    var name: String = ""
    var type: String = ""
    var price: Float = 0.0
    
    // Optionals
    var dietaryImages: [UIImage] = []
    var imageString: String? = nil
    var image: UIImage? = nil
    var description: String? = nil
    var ingredients: [String]? = nil
    var sides: [String]? = nil
    var pescatarian: Bool? = nil
    var vegan: Bool? = nil
    var gf: Bool? = nil
    var vegetarian: Bool? = nil
    
    init(name: String,
         type: String,
         price: Float,
         imageString: String?,
         description: String?,
         ingredients: [String]?,
         sides: [String]?,
         pescatarian: Bool?,
         vegan: Bool?,
         gf: Bool?,
         vegetarian: Bool?)
    {
        self.name = name
        self.type = type
        self.price = price
        
        self.imageString = imageString
        self.description = description
        self.ingredients = ingredients
        self.sides = sides
        self.pescatarian = pescatarian
        self.vegan = vegan
        self.gf = gf
        self.vegetarian = vegetarian
    }
}
