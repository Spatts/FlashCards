//
//  Subject.swift
//  FlashCards
//
//  Created by Steven Patterson on 8/25/16.
//  Copyright © 2016 Steven Patterson. All rights reserved.
//

import Foundation
import CloudKit

class Subject: CloudKitSyncable {
    static let kTopic = "Topic"
    static let kTitle = "Title"
    static let RecordType = "Subject"
    
    var topic: String
    var title: String
    var cards: [Card] = []
    var cloudKitRecordID: CKRecordID?
    var recordType: String { return Subject.RecordType}
    
    init(topic: String, title:String, cards: [Card] = []) {
        self.topic = topic
        self.title = title
        self.cards = cards
    }
    
    convenience required init?(cloudKitRecord: CKRecord) {
        guard let topic = cloudKitRecord[Subject.kTopic] as? String,
        title = cloudKitRecord[Subject.kTitle] as? String where cloudKitRecord.recordType == Subject.RecordType
        else {return nil}
        
        self.init(topic: topic, title: title)
        
        cloudKitRecordID = cloudKitRecord.recordID
    }
}

extension CKRecord {
    convenience init(_ subject: Subject) {
        let recordID = CKRecordID(recordName: NSUUID().UUIDString)
        self.init(recordType: Subject.RecordType, recordID: recordID)
        
        self[Subject.kTopic] = subject.topic
        self[Subject.kTitle] = subject.title
    }
    
    //    var cloudKitRecord: CKRecord {
    //        let recordID = CKRecordID(recordName: NSUUID().UUIDString)
    //        let record = CKRecord(recordType: Subject.recordType, recordID: recordID)
    //
    //        record[Subject.kTopic] = topic
    //        record[Subject.kTitle] = title
    //        return record
    //    }
}