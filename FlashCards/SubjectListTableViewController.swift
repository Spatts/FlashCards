//
//  SubjectListTableViewController.swift
//  FlashCards
//
//  Created by Steven Patterson on 8/30/16.
//  Copyright © 2016 Steven Patterson. All rights reserved.
//

import UIKit

class SubjectListTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var createdSubject: Subject?
    
    var arrayFromSearch: [Subject] = []
    
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.reloadTable), name: SubjectController.subjectsChangedNotification, object: nil)
        setupSearchController()
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
   
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    
    @IBAction func addTapped(sender: AnyObject) {
        // TODO: AlertController
        
        var textfield1: UITextField?
        var textfield2: UITextField?
        
        let alert = UIAlertController(title: "Add A Subject", message: nil, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Subject"
            textfield1 = textField
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Title"
            textfield2 = textField
        }
       
        
        let createAction = UIAlertAction(title: "Create", style: .Default) { (_) in
            guard let topic = textfield1?.text,
                title = textfield2?.text else {return}
            let subject = Subject(topic: topic, title: title)
            self.createdSubject = subject
            SubjectController.sharedController.subjects.append(subject)
            SubjectController.sharedController.saveSubjectToCK(subject) { (error) in
                if error != true {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.performSegueWithIdentifier("addCards", sender: self)
                    
                    })

                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SubjectController.sharedController.subjects.count
    }
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("subjectList", forIndexPath: indexPath) 
        
        let subject = SubjectController.sharedController.subjects[indexPath.row]
        cell.textLabel?.text = subject.topic
        cell.detailTextLabel?.text = subject.title
        
        return cell
    }
    
     //Mark: - SearchController
    
    func setupSearchController() {
        let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SearchResultsTableViewController")
        searchController = UISearchController(searchResultsController: resultsController)
        guard let searchController = searchController else {return}
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search Topic"
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text,
            resultsController = searchController.searchResultsController as? SearchResultsTableViewController else {return}
        
        resultsController.resultsArray = SubjectController.sharedController.matchesSearchTerm(searchTerm)
        resultsController.tableView.reloadData()
    }
    

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addCards" {
            if let viewController = segue.destinationViewController as? AddCardViewController {
                viewController.subject = self.createdSubject
            }
        } else if segue.identifier == "toDetail" {
            if let viewController = segue.destinationViewController as? CardDetailTableViewController {
                guard let indexPath = tableView.indexPathForSelectedRow else {
                    print("IndexPath Failed")
                    return}
                let subject = SubjectController.sharedController.subjects[indexPath.row]
                viewController.subject = subject
            }
            
            
        }
    }
}
