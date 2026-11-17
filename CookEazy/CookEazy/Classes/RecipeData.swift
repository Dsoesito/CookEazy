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
    var cookTimeMinutes: Int? // in minutes
    var servings: Int?
    var steps: String?
    var isTemplate: Bool?
    var source: String?
    var createdAt: String?
    var ingredients: [RecipeIngredient]?

    func initWithData(
        theId: Int = 0,
        theName: String = "",
        theCookTimeMinutes: Int = 0,
        theServings: Int = 0,
        theSteps: String = "",
        theIsTemplate: Bool = false,
        theSource: String = "",
        theCreatedAt: String = "",
        theIngredients: [RecipeIngredient] = []
    ) {
        self.id = theId
        self.name = theName
        self.cookTimeMinutes = theCookTimeMinutes
        self.servings = theServings
        self.steps = theSteps
        self.isTemplate = theIsTemplate
        self.source = theSource
        self.createdAt = theCreatedAt
        self.ingredients = theIngredients
    }
}
