//
//  RecipeIngredientData.swift
//  CookEazy
//
//  Author: Daniel Soesito
//  Created on 2026-11-18.
//

import UIKit

// Model for one ingredient line inside a recipe: an ingredient plus how much of it.

class RecipeIngredientData : NSObject {

    var ingredient: IngredientData?
    var quantity: Double?
    var position: Int?

    // Calories for this line; computed so it can never go out of date
    var calories: Double {
        return (quantity ?? 0) * (ingredient?.caloriesPerUnit ?? 0)
    }

    func initWithData(
        theIngredient: IngredientData? = nil,
        theQuantity: Double = 0.0,
        thePosition: Int = 0
    ) {
        self.ingredient = theIngredient
        self.quantity = theQuantity
        self.position = thePosition
    }
}
