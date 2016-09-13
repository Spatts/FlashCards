//
//  CardDetailTableViewController.swift
//  FlashCards
//
//  Created by Steven Patterson on 8/30/16.
//  Copyright © 2016 Steven Patterson. All rights reserved.
//

import UIKit

class CardDetailTableViewController: UITableViewController {
    
    var subject: Subject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let subject = subject else {
            return
        }
        
        SubjectController.sharedController.fetchCardsForSubject(subject) { (cards, _) in
//            self.subject?.cards = cards
            print("Here are all the cards on \(#function) line \(#line): \n\(subject.cards.count)")
//            self.reloadTable()
            
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadTable), name: SubjectController.subjectsCardsChangedNotification, object: nil)
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("TVC count = \(subject?.cards.count)")
        print("Subjects count = \(self.subject?.cards.count)")
        guard let subject = subject else { return 0 }
        return subject.cards.count
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    //    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return 420
    //    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as? customDetailTableViewCell else {return UITableViewCell()}
        
        guard let subject = subject else { return UITableViewCell() }
        
        let card = subject.cards[indexPath.row]
        print("Hey here is the question: \(card.question)")
        cell.updateCardCells(card, subject: subject)
        return cell
    }
    
    
}
