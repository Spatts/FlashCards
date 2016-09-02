//
//  addCardTableViewCell.swift
//  FlashCards
//
//  Created by Steven Patterson on 9/1/16.
//  Copyright © 2016 Steven Patterson. All rights reserved.
//

import UIKit

class addCardTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateNewCardCell(card: Card) {
        questionLabel.text = card.question
        answerLabel.text = card.answer
    }

}
