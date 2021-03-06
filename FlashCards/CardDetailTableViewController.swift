//
//  CardDetailTableViewController.swift
//  FlashCards
//
//  Created by Steven Patterson on 8/30/16.
//  Copyright © 2016 Steven Patterson. All rights reserved.
//

import UIKit
import MessageUI

class CardDetailTableViewController: UITableViewController, MFMailComposeViewControllerDelegate{
    
    var subject: Subject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.373, green: 0.420, blue: 0.502, alpha: 1.00)
        navigationController?.navigationBar.tintColor = UIColor(red: 0.290, green: 0.294, blue: 0.294, alpha: 1.00)

        guard let subject = subject else { return }
        
        title = subject.title
        navigationItem.prompt = subject.topic
        
        SubjectController.sharedController.fetchCardsForSubject(subject) { (cards, _) in
//            print("Here are all the cards on \(#function) line \(#line): \n\(subject.cards.count)")
            
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadTable), name: SubjectController.subjectsCardsChangedNotification, object: nil)
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let subject = subject else { return 0 }
        return subject.cards.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as? customDetailTableViewCell else {return UITableViewCell()}
        
        guard let subject = subject else { return UITableViewCell() }
        let card = subject.cards[indexPath.row]
        print("Hey here is the question: \(card.question)")
        cell.updateCardCells(card, subject: subject)
        return cell
    }
    
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if tableView.indexPathForSelectedRow == indexPath {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return nil
        }
        return indexPath
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let additionalSeparatorThickness = CGFloat(12)
        let additionalSeparator = UIView(frame: CGRectMake(0,
            cell.frame.size.height - additionalSeparatorThickness,
            cell.frame.size.width,
            additionalSeparatorThickness))
        additionalSeparator.backgroundColor = UIColor(red: 0.906, green: 0.906, blue: 0.906, alpha: 1.00)
        cell.addSubview(additionalSeparator)
        
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let frameHeight = tableView.frame.size.height - 18
        
        
        return frameHeight
    }
    
    
    func cellButtonTapped(tapped: Bool) {
        if tapped == true {
            print("Remove the blur")
        }
    }

    
    @IBAction func reportButtonTapped(sender: AnyObject) {
        let alert = UIAlertController(title: "Send Report?", message: nil, preferredStyle: .Alert)
        
        let yesButton = UIAlertAction(title: "Yes", style: .Default) { (_) in
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["communityflashcards@gmail.com"])
                mail.setMessageBody("Subject topic is \(self.subject?.topic) and the title is \(self.subject?.title)", isHTML: true)
                self.presentViewController(mail, animated: true, completion: nil)
            } else {
                print("Unable to send report")
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(yesButton)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
