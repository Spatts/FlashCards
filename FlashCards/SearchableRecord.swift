//
//  SearchableRecord.swift
//  FlashCards
//
//  Created by Steven Patterson on 8/30/16.
//  Copyright © 2016 Steven Patterson. All rights reserved.
//

import Foundation

protocol SearchableRecord {
    
    func matchesSearchTerm(searchTerm: String) -> Bool
}