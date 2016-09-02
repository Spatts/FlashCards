//
//  CloudKitSyncable.swift
//  FlashCards
//
//  Created by Steven Patterson on 8/30/16.
//  Copyright © 2016 Steven Patterson. All rights reserved.
//

import Foundation
import CloudKit
import CloudKit

protocol CloudKitSyncable {
	
	init?(cloudKitRecord: CKRecord)

	var cloudKitRecordID: CKRecordID? { get set }
	var recordType: String { get }
}

extension CloudKitSyncable {
	var isSynced: Bool {
		return cloudKitRecordID != nil
	}
	
	var cloudKitReference: CKReference? {
		
		guard let recordID = cloudKitRecordID else { return nil }
		
		return CKReference(recordID: recordID, action: .None)
	}
}
