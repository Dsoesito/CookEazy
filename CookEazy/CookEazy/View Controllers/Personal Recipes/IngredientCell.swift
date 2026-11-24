/*
This code was developed by:
- Matteo Piraino 991677520
- Project Title: CookEazy
- Date: 2026-11-23
*/


// Include the UIKit library to build the table row
import UIKit



// -------------------- INGREDIENT CELL --------------------

// Class used to show one ingredient row, with the name on the left and calories on the right
// Its layout is the "IngredientCell" prototype on the Your Recipe page in Main.storyboard
class IngredientCell: UITableViewCell {

    // Ingredient name box on the left
    @IBOutlet weak var nameField: UITextField!

    // Calories box on the right
    @IBOutlet weak var caloriesField: UITextField!

    // Code the form page runs when either box changes
    var onChange: ((IngredientRow) -> Void)?


    // Fills both boxes with a row's name and calories
    func configure(with row: IngredientRow) {
        nameField.text = row.name
        caloriesField.text = row.calories
    }


    // Runs each time a letter or number is typed in either box
    @IBAction func fieldChanged(_ sender: UITextField) {

        // Keeps only digits in the calories box
        caloriesField.text = caloriesField.text?.filter(\.isNumber)

        // Sends the updated row back to the form page
        onChange?(IngredientRow(name: nameField.text ?? "", calories: caloriesField.text ?? ""))
    }


    // Hides the keyboard when Done is pressed on the ingredient name
    @IBAction func returnTapped(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
