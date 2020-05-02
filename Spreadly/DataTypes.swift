//
//  DataTypes.swift
//  Spreadly
//
//  Created by Michael Wlodawsky on 5/2/20.
//  Copyright © 2020 Spreadly. All rights reserved.
//

import Foundation

class MenuItem {
    var name: String = ""
    var type: String = ""
    var price: Float = 0.0
    
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
        
        self.description = description
        self.ingredients = ingredients
        self.sides = sides
        self.pescatarian = pescatarian
        self.vegan = vegan
        self.gf = gf
        self.vegetarian = vegetarian
    }
}
