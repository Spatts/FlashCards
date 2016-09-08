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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectLabel.text = subject?.topic
        titleLabel.text = subject?.title
        
        //        let subject = Subject(topic: "foo", title: "bar")
        //
        //        SubjectController.sharedController.saveSubject(subject) { _ in }
        
        // later...
        
//        guard let subject = subject else {return}
//        let card = Card(question: "hi", answer: "you", subject: subject)
//        SubjectController.sharedController.saveCardToCK(card, subject: subject) { (error, card) in
//            
//        }
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addCardButtonTapped(sender: AnyObject) {
        
        guard let question = questionTextView.text, answer = answerTextView.text else { return }
        
        print(question)
        
        let card = Card(question: question, answer: answer, subject: subject)
        SubjectController.sharedController.saveCardToCK(card, subject: subject)
        questionTextView.text = ""
        answerTextView.text = ""
        self.tableView.reloadData()
    }
    
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        
        
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
    
    

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
