//
//  RecentsTableViewCell.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/5/22.
//  muljo@usc.edu

import UIKit

// Class for the recent exercises cells in the recents table within the Home tab
class RecentsTableViewCell: UITableViewCell {

    @IBOutlet weak var workoutName: UILabel!
    
    @IBOutlet weak var lengthLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
