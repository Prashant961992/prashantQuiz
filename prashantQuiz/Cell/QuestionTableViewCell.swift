//
//  QuestionTableViewCell.swift
//  prashantQuiz
//
//  Created by Prashant Prajapati on 17/04/23.
//

import UIKit

/**
 A custom `UITableViewCell` subclass that represents a single question in a quiz app.
 */
class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblQuestions: UILabel!
    @IBOutlet weak var imgSelection: UIImageView!
    @IBOutlet weak var viewCellBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
