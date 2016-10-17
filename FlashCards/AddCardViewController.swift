//
//  AddCardViewController.swift
//  FlashCards
//
//  Created by Steven Patterson on 8/30/16.
//  Copyright © 2016 Steven Patterson. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var questionTextView: UITextView!
    
    @IBOutlet weak var answerTextView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!


    var subject: Subject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextView.delegate = self
        answerTextView.delegate = self
        betterTextViews()
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
        guard let subject = subject
            else {
                print("this is you subjects Title Crazy!! \(self.subject?.title)")
                return}
        guard let question = questionTextView.text,
        let answer = answerTextView.text else { return }
        
        let card = Card(question: question, answer: answer, subject: subject)
        SubjectController.sharedController.saveCardToCK(card, subject: subject)
        print(card.question)
        reloadingTextViews()
        
    }
    
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let subject = subject else { return 0 }
        return subject.cards.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("newCardCell", forIndexPath: indexPath) as? addCardTableViewCell, subject = subject else {return addCardTableViewCell()}
        
        let card = subject.cards[indexPath.row]
        cell.updateNewCardCell(card, subject: subject)
        
        return cell
    }
    

    
    func reloadingTextViews() {
        questionTextView.text = "Write a Question/Term"
        questionTextView.textColor = UIColor.lightGrayColor()
        answerTextView.text = "Write an Answer/Definition"
        answerTextView.textColor = UIColor.lightGrayColor()
        self.tableView.reloadData()
    }
    
    func betterTextViews() {
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

    
}
