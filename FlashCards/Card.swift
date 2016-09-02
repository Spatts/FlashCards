//
//  Card.swift
//  FlashCards
//
//  Created by Steven Patterson on 8/25/16.
//  Copyright © 2016 Steven Patterson. All rights reserved.
//

import Foundation
import CloudKit

class Card: CloudKitSyncable {
    static let kQuestion = "Question"
    static let kAnswer = "Answer"
    static let RecordType = "Card"
    static let subjectKey = "subject"
    
    var question: String
    var answer: String
    let subject: Subject?
    var cloudKitRecordID: CKRecordID?
    var recordType: String { return Card.RecordType}
    
    init(question: String, answer: String, subject: Subject?) {
        
        self.answer = answer
        self.question = question
        self.subject = subject
        subject?.cards.append(self)
    }
    

    
    convenience required init?(cloudKitRecord:CKRecord) {
        guard let question = cloudKitRecord[Card.kQuestion] as? String,
        answer = cloudKitRecord[Card.kAnswer] as? String
        where cloudKitRecord.recordType == Card.RecordType
            else {return nil}
        
        
        self.init(question: question, answer: answer, subject: nil)
        
        cloudKitRecordID = cloudKitRecord.recordID
    }
    
    
}

extension CKRecord {
    convenience init(_ card: Card) {
        guard let subject = card.subject, cloudKitRecordID = subject.cloudKitRecordID else {fatalError("Card doesn't have a relationship with Subject")}
        let recordID = CKRecordID(recordName: NSUUID().UUIDString)
        self.init(recordType: Card.RecordType, recordID: recordID)
        
        self[Card.kQuestion] = card.question
        self[Card.kAnswer] = card.answer
        self[Card.subjectKey] = CKReference(recordID: cloudKitRecordID, action: .None)
    }
    
    //    var cloudKitRecord: CKRecord {
    //        guard let subject = self.subject, cloudKitRecordID = subject.cloudKitRecordID else {fatalError("Card doesn't have a relationship with Subject")}
    //        let recordID = CKRecordID(recordName: NSUUID().UUIDString)
    //        let record = CKRecord(recordType: Card.recordType, recordID: recordID)
    //
    //        record[Card.kQuestion] = question
    //        record[Card.kAnswer] = answer
    //        record[Card.subjectKey] = CKReference(recordID: cloudKitRecordID, action: .None)
    //
    //        return record
    //    }
}