//
//  SubjectController.swift
//  FlashCards
//
//  Created by Steven Patterson on 8/25/16.
//  Copyright © 2016 Steven Patterson. All rights reserved.
//

import Foundation
import CloudKit

class SubjectController {
    static let sharedController = SubjectController()
    static let subjectsChangedNotification = "SubjectsChanged"
    static let subjectsCardsChangedNotification = "SubjectsCardsChanged"
    
    private let cloudKitManager = CloudKitManager()
    
    var subjects = [Subject]() {
        didSet {
            dispatch_async(dispatch_get_main_queue()) {
                let nc = NSNotificationCenter.defaultCenter()
                nc.postNotificationName(SubjectController.subjectsChangedNotification, object: self)
            }
        }
    }
    
    var cards: [Card] {
        return subjects.flatMap { $0.cards}
    }
    
    
    func saveSubjectToCK(subject: Subject, completion: (NSError?)-> Void) {
        // TODO: Save to server
        // let record = subject.cloudKitRecord
        
        cloudKitManager.saveRecord(CKRecord(subject)) { (record, error) in
            defer {completion(error)}
            if let error = error {
                print("Error saving \(subject) to CloudKit \(error.localizedDescription)")
            }
            subject.cloudKitRecordID = record?.recordID
            
        }
    }
    
    func saveCardToCK(card: Card, subject: Subject?, completion: ((error: NSError?, card: Card?)-> Void)? = nil) {
        // let record = card.cloudKitRecord
        guard let subject = subject else {return}
        
        subject.cards.append(card)
        
        cloudKitManager.saveRecord(CKRecord(card)) { (record, error) in
            defer {completion?(error: error, card: nil)}
            if let error = error {
                print("Error saving new Card to CloudKit: \(error.localizedDescription)")
            }
            card.cloudKitRecordID = record?.recordID
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            let notification = NSNotificationCenter.defaultCenter()
            notification.postNotificationName(SubjectController.subjectsCardsChangedNotification, object: subject)
            completion?(error: nil, card: card)
        }

        
//        saveCardToCloudKit(card, subject)
    }
    
    func fetchRecords() {
        
        
    }
    
    
    
}