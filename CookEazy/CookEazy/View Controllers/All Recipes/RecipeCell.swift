//
//  RecipeCell.swift
//  CookEazy
//
//  Created by Daniel Soesito on 2026-11-25.
//

import UIKit

class RecipeCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var cookTimeLabel: UILabel!
    @IBOutlet var servingsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
