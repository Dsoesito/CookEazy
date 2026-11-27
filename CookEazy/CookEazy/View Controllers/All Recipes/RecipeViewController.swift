//
//  RecipeViewController.swift
//  CookEazy
//
//  Created by Daniel Soesito on 2026-11-26.
//

import UIKit

class RecipeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let mainDelegate = UIApplication.shared.delegate as! AppDelegate

    var recipe: RecipeData?

    @IBOutlet weak var tableView: UITableView!

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return 1
        case 1:
            return recipe?.ingredients?.count ?? 0
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.section {

        // Section 0: Recipe Information
        case 0:

            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeInfoCell", for: indexPath) as! RecipeInfoCell

            cell.nameLabel.text = recipe?.name ?? ""
            cell.cookTimeLabel.text = "\(recipe?.cookTimeMinutes ?? 0) min"
            cell.servingsLabel.text = "\(recipe?.servings ?? 0) servings"

            cell.templateLabel.text = recipe?.isTemplate == true ? "Yes" : "No"
            cell.createdAtLabel.text = recipe?.createdAt ?? ""

            return cell

        // Section 1: Ingredients
        case 1:

            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeIngredientCell", for: indexPath) as! RecipeIngredientCell

            let ingredientLine = recipe?.ingredients?[indexPath.row]

            cell.ingredientNameLabel.text = ingredientLine?.ingredient?.name ?? ""

            cell.quantityLabel.text = String(format: "%g", ingredientLine?.quantity ?? 0)

            cell.unitLabel.text = ingredientLine?.ingredient?.unit ?? ""

            return cell

        // Section 2: Instructions
        case 2:

            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeStepsCell", for: indexPath) as! RecipeStepsCell

            cell.stepsLabel.text = recipe?.steps ?? ""

            return cell

        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {
        case 0:
            return nil
        case 1:
            return "Ingredients"
        case 2:
            return "Instructions"
        default:
            return nil
        }
    }
    
    // used AI for dynamic sell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }

}
