//
//  SubjectListTableViewController.swift
//  FlashCards
//
//  Created by Steven Patterson on 8/30/16.
//  Copyright © 2016 Steven Patterson. All rights reserved.
//

import UIKit

class SubjectListTableViewController: UITableViewController {
    
    var createdSubject: Subject?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        return 0
    }
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        // Configure the cell...
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
   
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "addCards" {
            if let viewController = segue.destinationViewController as? AddCardViewController {
                viewController.subject = self.createdSubject
            }
        } else if segue.identifier == "toDetail" {
            _ = segue.destinationViewController as? CardDetailTableViewController
            
        }
    }
}
