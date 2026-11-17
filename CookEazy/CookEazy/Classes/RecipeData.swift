//
//  RecipeData.swift
//  CookEazy
//
//  Created by Daniel Soesito on 2026-11-16.
//

import UIKit

// Model for one recipe. Holds data only; calorie totals are computed from ingredients.

class RecipeData : NSObject {

    var id: Int?
    var name: String?
    var cookTime: Int? // in minutes
    var steps: String?
    var ingredients: [IngredientData]?

    func initWithData(
        theId: Int = 0,
        theName: String = "",
        theCookTime: Int = 0,
        theSteps: String = "",
        theIngredients: [IngredientData] = []
    ) {
        self.id = theId
        self.name = theName
        self.cookTime = theCookTime
        self.steps = theSteps
        self.ingredients = theIngredients
    }
}
