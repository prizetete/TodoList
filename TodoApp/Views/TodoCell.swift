//
//  TodoCell.swift
//  TodoApp
//
//  Created by Komkrit.Sir on 25/3/2564 BE.
//

import UIKit

class TodoCell: UITableViewCell {
    @IBOutlet weak var todoDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.todoDescriptionLabel.textColor = .black
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
