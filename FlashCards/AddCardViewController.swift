//
//  AddCardViewController.swift
//  FlashCards
//
//  Created by Steven Patterson on 8/30/16.
//  Copyright © 2016 Steven Patterson. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
    
    
    @IBOutlet weak var questionTextView: UITextView!
    
    @IBOutlet weak var answerTextView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!


    var subject: Subject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextView.delegate = self
        answerTextView.delegate = self
//        subjectTopicItem.title = subject?.topic
//        navigationItem.title = subject?.title
        
        questionTextView.contentOffset = CGPointZero
        answerTextView.contentOffset = CGPointZero

        questionTextView.layer.borderColor = UIColor.blackColor().CGColor
        answerTextView.layer.borderColor = UIColor.blackColor().CGColor
        
        questionTextView.layer.borderWidth = 0.5
        answerTextView.layer.borderWidth = 0.5
        
        questionTextView.layer.cornerRadius = 10
        answerTextView.layer.cornerRadius = 10
        
        questionTextView.text = "Write a Question/Term"
        questionTextView.textColor = UIColor.lightGrayColor()
        answerTextView.text = "Write an Answer/Definition"
        answerTextView.textColor = UIColor.lightGrayColor()
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if textView == questionTextView {
            if questionTextView.textColor == UIColor.lightGrayColor() {
                questionTextView.text = ""
                questionTextView.textColor = UIColor.blackColor()
            }
        } else if textView == answerTextView {
            if answerTextView.textColor == UIColor.lightGrayColor() {
                answerTextView.text = ""
                answerTextView.textColor = UIColor.blackColor()
            }
        }
    }
    
    
    @IBAction func addCardButtonTapped(sender: AnyObject) {
        
        guard let question = questionTextView.text, answer = answerTextView.text else { return }
        
        let card = Card(question: question, answer: answer, subject: subject)
        SubjectController.sharedController.saveCardToCK(card, subject: subject)
        print(card.question)
        questionTextView.text = "Write a Question/Term"
        questionTextView.textColor = UIColor.lightGrayColor()
        answerTextView.text = "Write an Answer/Definition"
        answerTextView.textColor = UIColor.lightGrayColor()
        self.tableView.reloadData()
        
    }
    
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.performSegueWithIdentifier("toDetailFromCreate", sender: self)
//        })
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
