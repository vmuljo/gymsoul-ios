//
//  ExerciseTableViewCell.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/4/22.
//  muljo@usc.edu

import UIKit

// Class for exercise table call from the exercises table (displays from API)
class ExerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var exerciseLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
