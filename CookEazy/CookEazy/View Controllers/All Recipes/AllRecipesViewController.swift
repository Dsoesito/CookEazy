//
//  AllRecipesViewController.swift
//  CookEazy
//
//  Created by Daniel Soesito on 2026-11-09.
//

import UIKit

class AllRecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.recipes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = mainDelegate.recipes[indexPath.row]

        let tableCell: RecipeCell = tableView.dequeueReusableCell(withIdentifier: "recipecell") as? RecipeCell ?? RecipeCell(style: .default, reuseIdentifier: "recipecell")

        tableCell.nameLabel.text = recipe.name ?? ""
        tableCell.cookTimeLabel.text = String(recipe.cookTimeMinutes ?? 0) + " min"
        tableCell.servingsLabel.text = String(recipe.servings ?? 0) + " servings"

        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = mainDelegate.recipes[indexPath.row]

        // Perform segue to recipe details view controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainDelegate.readRecipeDataFromDatabase()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
