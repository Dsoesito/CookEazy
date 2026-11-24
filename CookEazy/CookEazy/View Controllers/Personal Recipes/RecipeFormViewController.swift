/*
This code was developed by:
- Matteo Piraino 991677520
- Project Title: CookEazy
- Date: 2026-11-23
*/


// Include the UIKit library to build the screen
import UIKit



// -------------------- RECIPE FORM PAGE --------------------

// Class used to show page 2 of Personal Recipes: the recipe form
// Ingredient names go on the left and calories on the right
class RecipeFormViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // "Recipe Name" text box
    @IBOutlet weak var nameField: UITextField!

    // Table of ingredient rows
    @IBOutlet weak var tableView: UITableView!

    // Calorie total
    @IBOutlet weak var totalLabel: UILabel!

    // Add Ingredient, Total and Save area
    @IBOutlet weak var bottomStack: UIStackView!

    // Saved recipe being edited, empty for a new one
    // Set by the Recipe Creator page before this page opens
    var existingRecipe: RecipeData?

    // Name typed so far
    // Nothing is saved until Save Recipe is tapped, so Back throws the changes away
    var recipeName = ""

    // Ingredient rows typed so far
    var rows: [IngredientRow] = [IngredientRow()]


    // Runs once when the page is first loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        // Shows the recipe's current name and calorie total
        nameField.text = recipeName
        updateTotal()

        // Keeps Total and Save above the keyboard while typing
        view.keyboardLayoutGuide.topAnchor
            .constraint(greaterThanOrEqualTo: bottomStack.bottomAnchor, constant: 16)
            .isActive = true
    }


    // Adds up every row's calories and shows the total
    private func updateTotal() {
        let total = rows.reduce(0) { $0 + $1.calorieValue }
        totalLabel.text = "\(total) cal"
    }



    // -------------------- BUTTONS AND FIELDS --------------------

    // Goes back to the Recipe Creator page without saving
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }


    // Stores the recipe name each time a letter is typed
    @IBAction func nameChanged(_ sender: UITextField) {
        recipeName = sender.text ?? ""
    }


    // Hides the keyboard when Done is pressed on the name box
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }


    // Adds a new empty ingredient row to the bottom of the list
    @IBAction func addIngredientTapped(_ sender: Any) {

        // Adds the empty row to the list
        rows.append(IngredientRow())

        // Shows the new row and scrolls down to it
        let newRow = IndexPath(row: rows.count - 1, section: 0)
        tableView.insertRows(at: [newRow], with: .automatic)
        tableView.scrollToRow(at: newRow, at: .bottom, animated: true)
    }


    // Saves the recipe and moves to the "Recipe Created" page
    @IBAction func saveTapped(_ sender: Any) {

        // Closes the keyboard so the last typed value is kept
        view.endEditing(true)

        // Saves the recipe and shows the confirmation page
        RecipeStore.shared.save(makeRecipe())
        performSegue(withIdentifier: "showCreated", sender: nil)
    }


    // Builds a shared RecipeData from what is on screen
    // Keeps the id and creation date when editing, so the saved recipe is replaced instead of copied
    private func makeRecipe() -> RecipeData {

        // Turns each row into an ingredient line, numbered in screen order
        let lines = rows.enumerated().map { index, row in row.toRecipeIngredient(position: index) }

        // Fills in the recipe, marking it as a personal recipe rather than a template
        let recipe = RecipeData()
        recipe.initWithData(
            theId: existingRecipe?.id ?? 0,
            theName: recipeName,
            theIsTemplate: false,
            theSource: "Personal",
            theCreatedAt: existingRecipe?.createdAt ?? Self.timestamp(),
            theIngredients: lines
        )
        return recipe
    }


    // Gives the current date and time in the same format the database uses
    private static func timestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }


    // Runs just before moving to another page
    // Passes the recipe name to the confirmation page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // Sends the name only if the next page is the confirmation page
        if let created = segue.destination as? RecipeCreatedViewController {
            created.recipeName = recipeName
        }
    }



    // -------------------- TABLE --------------------

    // Tells the table how many rows to show
    // Gives one row per ingredient
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }


    // Builds the row for one ingredient and listens for edits to it
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Reuses an ingredient row from the storyboard and fills it in
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientCell
        cell.configure(with: rows[indexPath.row])

        // Stores the edited row and updates the total whenever it changes
        // Looks up the row again because rows can move after deleting
        cell.onChange = { [weak self, weak cell] row in
            guard let self, let cell, let index = tableView.indexPath(for: cell)?.row else { return }
            rows[index] = row
            updateTotal()
        }

        // Returns the finished row
        return cell
    }


    // Deletes an ingredient when its row is swiped left
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        // Ignores anything that is not a delete
        guard editingStyle == .delete else { return }

        // Removes the row, takes it off the screen, and updates the total
        rows.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        updateTotal()
    }
}
