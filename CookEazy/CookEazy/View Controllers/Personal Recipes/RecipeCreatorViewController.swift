/*
This code was developed by:
- Matteo Piraino 991677520
- Project Title: CookEazy
- Date: 2026-11-23
*/


// Include the UIKit library to build the screen
import UIKit



// -------------------- RECIPE CREATOR PAGE --------------------

// Class used to show page 1 of Personal Recipes: the list of saved recipes
// Opened full screen by the "Personal Recipes" button on the home screen
class RecipeCreatorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // List of saved recipes
    @IBOutlet weak var tableView: UITableView!

    // "No Recipes Created" message
    @IBOutlet weak var emptyStateView: UIView!

    // Where the personal recipes are kept
    private let store = RecipeStore.shared

    // The ways the Your Recipe page can be opened
    private enum FormStart {

        // "Add Your Recipe", an empty recipe
        case blank

        // "Use Our Template", the pancake recipe
        case template

        // A saved recipe tapped in the list
        case edit(RecipeData)
    }


    // Runs once when the page is first loaded
    override func viewDidLoad() {
        super.viewDidLoad()

        // Keeps these pages in light mode so the black text and warm colours always match the design
        navigationController?.overrideUserInterfaceStyle = .light
    }


    // Runs every time this page is about to appear, including when coming back to it
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Reloads the list so newly saved recipes show up
        tableView.reloadData()

        // Shows the empty message when there are no recipes, otherwise shows the list
        emptyStateView.isHidden = !store.recipes.isEmpty
        tableView.isHidden = store.recipes.isEmpty
    }



    // -------------------- BUTTONS --------------------

    // Closes Personal Recipes and goes back to the home screen
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true)
    }


    // Opens the form with a brand new, empty recipe
    @IBAction func addRecipeTapped(_ sender: Any) {
        performSegue(withIdentifier: "showForm", sender: FormStart.blank)
    }


    // Opens the form already filled in with the pancake template
    @IBAction func useTemplateTapped(_ sender: Any) {
        performSegue(withIdentifier: "showForm", sender: FormStart.template)
    }


    // Lets "Back to Recipe Creator" on page 3 jump straight back here
    // The storyboard finds this by its name, so do not rename it
    @IBAction func unwindToRecipeCreator(_ segue: UIStoryboardSegue) {}


    // Runs just before moving to another page
    // Tells the form which recipe to show
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // Stops if the next page is not the form or no starting point was passed
        guard let form = segue.destination as? RecipeFormViewController,
              let start = sender as? FormStart else { return }

        // Fills in the form based on which button or row was tapped
        switch start {

        // Leaves the form empty with one blank row
        case .blank:
            break

        // Fills the form with the template's name and ingredients
        case .template:
            form.recipeName = IngredientRow.templateName
            form.rows = IngredientRow.template

        // Fills the form with a saved recipe so it can be edited
        // Sorts the rows by position so they show in the order they were typed
        case .edit(let recipe):
            form.existingRecipe = recipe
            form.recipeName = recipe.name ?? ""
            let lines = (recipe.ingredients ?? []).sorted { ($0.position ?? 0) < ($1.position ?? 0) }
            form.rows = lines.isEmpty ? [IngredientRow()] : lines.map { IngredientRow(from: $0) }
        }
    }



    // -------------------- TABLE --------------------

    // Tells the table how many rows to show
    // Gives one row per saved recipe
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        store.recipes.count
    }


    // Builds the row for one recipe, with its name on the left and calories on the right
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Reuses a row from the storyboard and finds the recipe it should show
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        let recipe = store.recipes[indexPath.row]

        // Adds up the calories of every ingredient in the recipe
        let totalCalories = Int((recipe.ingredients ?? []).reduce(0) { $0 + $1.calories })

        // Sets the row's text, using "Untitled Recipe" when no name was typed
        var content = UIListContentConfiguration.valueCell()
        let name = recipe.name ?? ""
        content.text = name.isEmpty ? "Untitled Recipe" : name
        content.secondaryText = "\(totalCalories) cal"

        // Makes both pieces of text black to match the design
        content.textProperties.color = .black
        content.secondaryTextProperties.color = .black

        // Applies the text to the row and returns it
        cell.contentConfiguration = content
        return cell
    }


    // Opens the form to edit a recipe when its row is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Removes the grey highlight from the tapped row
        tableView.deselectRow(at: indexPath, animated: true)

        // Opens the form with the tapped recipe
        performSegue(withIdentifier: "showForm", sender: FormStart.edit(store.recipes[indexPath.row]))
    }
}
