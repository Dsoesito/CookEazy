//
//  IngredientData.swift
//  CookEazy
//
//  Author: Daniel Soesito
//  Created on 2026-11-18.
//

import UIKit

// Model for one item in the shared ingredient library. Holds data only.

class IngredientData : NSObject {

    var id: Int?
    var name: String?
    var unit: String? // unit the calories are measured per, e.g. "g", "tbsp"
    var caloriesPerUnit: Double?

    func initWithData(
        theId: Int = 0,
        theName: String = "",
        theUnit: String = "",
        theCaloriesPerUnit: Double = 0.0
    ) {
        self.id = theId
        self.name = theName
        self.unit = theUnit
        self.caloriesPerUnit = theCaloriesPerUnit
    }
}
