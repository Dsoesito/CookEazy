//
//  RecipeIngredientCell.swift
//  CookEazy
//
//  Created by Daniel Soesito on 2026-11-26.
//

import UIKit

class RecipeIngredientCell: UITableViewCell {
    
    @IBOutlet weak var ingredientNameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
