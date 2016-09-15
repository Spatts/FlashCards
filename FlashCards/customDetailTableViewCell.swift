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
    
    var blurView: UIVisualEffectView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func updateCardCells(card: Card, subject: Subject?) {
            self.questionLabel.text = card.question
            self.answerLabel.text = card.answer
            blurLabel()
            interactableLabel()
    }
    
    func blurLabel() {
        let blur = UIBlurEffect(style: .Dark)
        blurView = UIVisualEffectView(effect: blur)
        
        if let blurView = blurView {
        blurView.frame = answerLabel.bounds
        answerLabel.addSubview(blurView)
        blurView.hidden = false }
    }
    
    func interactableLabel() {
        answerLabel.userInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        answerLabel.addGestureRecognizer(gestureRecognizer)
        
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Began {
            blurView?.hidden = true
        } else {
            blurView?.hidden = false
        }
        
    }

}
