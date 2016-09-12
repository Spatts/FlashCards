//
//  AddCardViewController.swift
//  FlashCards
//
//  Created by Steven Patterson on 8/30/16.
//  Copyright © 2016 Steven Patterson. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var subjectLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var questionTextView: UITextView!
    
    @IBOutlet weak var answerTextView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!


    var subject: Subject?
    
    var cards: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectLabel.text = subject?.topic
        titleLabel.text = subject?.title
        
        questionTextView.text = "Write a Question/Term"
        questionTextView.textColor = UIColor.lightGrayColor()
        answerTextView.text = "Write an Answer/Definition"
        answerTextView.textColor = UIColor.lightGrayColor()
        
    }
    
    func textViewDidBeginEditing() {
        if questionTextView.textColor == UIColor.lightGrayColor() {
            questionTextView.text = nil
            questionTextView.textColor = UIColor.blackColor()
        }
        
        if answerTextView.textColor == UIColor.lightGrayColor() {
            answerTextView.text = nil
            answerTextView.textColor = UIColor.blackColor()
        }
    }
    
    
    
    
    @IBAction func addCardButtonTapped(sender: AnyObject) {
        
        guard let question = questionTextView.text, answer = answerTextView.text else { return }
        
        let card = Card(question: question, answer: answer, subject: subject)
        SubjectController.sharedController.saveCardToCK(card, subject: subject)
        self.cards.append(card)
        questionTextView.text = "Write a Question/Term"
        questionTextView.textColor = UIColor.lightGrayColor()
        answerTextView.text = "Write an Answer/Definition"
        answerTextView.textColor = UIColor.lightGrayColor()
        self.tableView.reloadData()
        
    }
    
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.performSegueWithIdentifier("toDetailFromCreate", sender: self)
        })
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SubjectController.sharedController.cards.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("newCardCell", forIndexPath: indexPath) as? addCardTableViewCell else {return addCardTableViewCell()}
        
        let card = SubjectController.sharedController.cards[indexPath.row]
        cell.updateNewCardCell(card)
        
        return cell
    }
    
    

    
     // MARK: - Navigation
     
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetailFromCreate" {
            if let viewController = segue.destinationViewController as? CardDetailTableViewController {
                viewController.subject = self.subject
//                viewController.cards = self.cards
            }
        }
    }
}
