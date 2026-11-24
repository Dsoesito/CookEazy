/*
This code was developed by:
- Matteo Piraino 991677520
- Project Title: CookEazy
- Date: 2026-11-23
*/


// Include the UIKit library to build the screen
import UIKit



// -------------------- RECIPE CREATED PAGE --------------------

// Class used to show page 3 of Personal Recipes: the "recipe saved" confirmation
// "Back to Recipe Creator" is an unwind segue set up in Main.storyboard
class RecipeCreatedViewController: UIViewController {

    // Big tick icon
    @IBOutlet weak var checkmarkImageView: UIImageView!

    // Name of the saved recipe
    @IBOutlet weak var recipeNameLabel: UILabel!

    // Name set by the form page before this page opens
    var recipeName = ""


    // Runs once when the page is first loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        // Shows the recipe's name, or hides the label if it has none
        recipeNameLabel.text = recipeName
        recipeNameLabel.isHidden = recipeName.isEmpty

        // Draws a black tick on a Light Caramel circle
        // Two-colour symbols can't be set in the storyboard, so this is done in code
        checkmarkImageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 96)
            .applying(UIImage.SymbolConfiguration(paletteColors: [.black, UIColor(named: "LightCaramel") ?? .black]))
    }


    // Goes back to the Recipe Form page
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
