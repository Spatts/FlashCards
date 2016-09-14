//
//  SearchResultsTableViewController.swift
//  FlashCards
//
//  Created by Steven Patterson on 8/30/16.
//  Copyright © 2016 Steven Patterson. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    var resultsArray: [Subject] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return resultsArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("resultsCell", forIndexPath: indexPath)
        let result = resultsArray[indexPath.row]
        
        cell.textLabel?.text = result.topic
        cell.detailTextLabel?.text = result.title
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
    
        print(self.presentingViewController)
        let result = resultsArray[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let dvc = storyboard.instantiateViewControllerWithIdentifier("CardDetailTableViewController") as? CardDetailTableViewController else { return }
        dvc.subject = result
        self.presentingViewController?.performSegueWithIdentifier("toDetail", sender: cell)
    }
    
    

}
