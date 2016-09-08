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
    
    var cards: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let subject = subject else {
            return
        }
        
        SubjectController.sharedController.fetchCardsForSubject(subject) { (error) in
            if error != nil {
                print("unable to fetch cards in detail view")
            }
            
            
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadTable), name: SubjectController.subjectsCardsChangedNotification, object: nil)
    }

    func reloadTable() {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return SubjectController.sharedController.cards.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as? customDetailTableViewCell else {return UITableViewCell()}
        
        let card = SubjectController.sharedController.cards[indexPath.row]
        
        cell.updateCardCells(card, subject: subject)
        
        return cell
    }
    

}
