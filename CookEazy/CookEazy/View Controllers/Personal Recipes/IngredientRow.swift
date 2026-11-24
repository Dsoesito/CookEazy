/*
This code was developed by:
- Matteo Piraino 991677520
- Project Title: CookEazy
- Date: 2026-11-23
*/


// Include the Foundation library for basic types
import Foundation



// -------------------- INGREDIENT ROW --------------------

// Struct used to store one ingredient row while the user is typing
// Turned into the shared RecipeIngredientData and IngredientData classes when the recipe is saved
struct IngredientRow {
    // Ingredient name, including its amount
    var name: String = ""

    // Calories typed by the user, digits only
    var calories: String = ""

    // Turns the typed calories into a number
    // Gives 0 when the box is empty so totals still add up
    var calorieValue: Int {
        Int(calories) ?? 0
    }
}



// -------------------- CONVERTING TO AND FROM SHARED CLASSES --------------------

extension IngredientRow {

    // Creates a row from one ingredient line of a saved recipe
    init(from line: RecipeIngredientData) {

        // Copies the ingredient's name
        name = line.ingredient?.name ?? ""

        // Copies the line's calories, leaving the box empty when there are none
        let total = Int(line.calories)
        calories = total == 0 ? "" : String(total)
    }


    // Turns this row into an ingredient line for the shared RecipeData class
    // Each row counts as 1 serving, so its calories per unit are the calories typed
    func toRecipeIngredient(position: Int) -> RecipeIngredientData {

        // Creates the ingredient with its name and calories
        let ingredient = IngredientData()
        ingredient.initWithData(theName: name, theUnit: "serving", theCaloriesPerUnit: Double(calorieValue))

        // Creates the recipe line holding 1 serving of that ingredient
        let line = RecipeIngredientData()
        line.initWithData(theIngredient: ingredient, theQuantity: 1, thePosition: position)
        return line
    }
}



// -------------------- TEMPLATE --------------------

// Test recipe offered by the "Use Our Template" button
extension IngredientRow {

    // Recipe name shown on the form
    static let templateName = "Classic Pancakes"

    // Ingredient rows shown on the form
    static let template: [IngredientRow] = [
        IngredientRow(name: "Flour (1 cup)", calories: "455"),
        IngredientRow(name: "Milk (1 cup)", calories: "122"),
        IngredientRow(name: "Eggs (2)", calories: "144"),
        IngredientRow(name: "Butter (1 tbsp)", calories: "102"),
        IngredientRow(name: "Sugar (2 tbsp)", calories: "96"),
    ]
}
