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
    
    let publicDatabase = CKContainer.defaultContainer().publicCloudDatabase
    
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
    
    init() {
        fetchSubject { (error) in
            if let error = error {
                print("Error fetching Subjects on StartUP \(error.localizedDescription)")
            }
        }
        
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
    
    func saveCardToCK(card: Card, subject: Subject, completion: ((error: NSError?, card: Card?)-> Void)? = nil) {
        // let record = card.cloudKitRecord
//        guard let subject = subject else {return}
        
        subject.cards.append(card)
        
        cloudKitManager.saveRecord(CKRecord(card)) { (record, error) in
            if let error = error {
                print("Error saving new Card to CloudKit: \(error.localizedDescription)")
            }
            card.cloudKitRecordID = record?.recordID
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            completion?(error: nil, card: card)
            let notification = NSNotificationCenter.defaultCenter()
            notification.postNotificationName(SubjectController.subjectsCardsChangedNotification, object: subject)
        }

        
//        saveCardToCloudKit(card, subject)
    }
    
    func fetchSubject(completion: (NSError?)-> Void) {
        cloudKitManager.fetchRecordsWithType(Subject.RecordType, recordFetchedBlock: nil) { (records, error) in
            defer {completion(error)}
            if let error = error {
                print("Error fetching Subjects: \(error.localizedDescription)")
                return
            }
            
            guard let records = records else {return}
            self.subjects = records.flatMap {Subject(cloudKitRecord: $0)}
            
        }
    }
    
    
    
    func fetchCardsForSubject(subject: Subject, completion: (cards: [Card], NSError?)-> Void) {
        guard let recordID = subject.cloudKitRecordID else { return }
        
        let predicate = NSPredicate(format: "subject == %@", recordID)
        
        let query = CKQuery(recordType: "Card", predicate: predicate)
        
        publicDatabase.performQuery(query, inZoneWithID: nil) { (records, error) in            
            if error != nil {
                print("There is a problem performing Query: \(error?.localizedDescription)")
            } else {
                guard let records = records else { return }
                
                for record in records {
                    guard let card = Card(cloudKitRecord: record) else { return }
                    subject.cards.append(card)
                    print(card.question)
                }
            }
            
            
            dispatch_async(dispatch_get_main_queue()) {
                completion(cards: self.cards, nil)
                let notification = NSNotificationCenter.defaultCenter()
                notification.postNotificationName(SubjectController.subjectsCardsChangedNotification, object: subject)
                
            }
        }
    }

        
    func matchesSearchTerm(searchTerm: String) -> [Subject] {
        let matchingTopic = SubjectController.sharedController.subjects.filter {$0.topic.lowercaseString.containsString(searchTerm.lowercaseString)}
        return matchingTopic
    }
}








