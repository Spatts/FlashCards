//
//  customDetailTableViewCell.swift
//  FlashCards
//
//  Created by Steven Patterson on 9/1/16.
//  Copyright © 2016 Steven Patterson. All rights reserved.
//

import UIKit

class customDetailTableViewCell: UITableViewCell {
        
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func updateCardCells(card: Card, subject: Subject?) {
            self.questionLabel.text = card.question
            self.answerLabel.text = card.answer
    }


}
