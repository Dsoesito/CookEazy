/*
This code was developed by:
- Matteo Piraino 991677520
- Project Title: CookEazy
- Date: 2026-11-23
*/


// Include the Foundation library for basic types
import Foundation



// -------------------- RECIPE STORE --------------------

// Class used to store the user's personal recipes while the app is running
// Nothing is saved to the database yet, so recipes are lost when the app closes
final class RecipeStore {

    // The one store the whole app shares
    static let shared = RecipeStore()

    // Every saved recipe, only this class can change it
    private(set) var recipes: [RecipeData] = []

    // Id the next new recipe gets, like autoincrement
    private var nextId = 1


    // Saves a recipe, replacing the old copy if one has the same id
    // Gives the recipe an id first if it does not have one yet
    func save(_ recipe: RecipeData) {

        // Gives a brand new recipe the next free id
        if (recipe.id ?? 0) == 0 {
            recipe.id = nextId
            nextId += 1
        }

        // Replaces the recipe if it was saved before
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index] = recipe

        // Adds it as a new recipe otherwise
        } else {
            recipes.append(recipe)
        }
    }
}
