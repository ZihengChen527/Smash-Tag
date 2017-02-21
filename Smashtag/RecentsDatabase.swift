//
//  RecentsDatabase.swift
//  Smashtag
//
//  Created by Ziheng Chen on 2/15/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import Foundation

class RecentsDatabase {
    
    private let defaults = UserDefaults.standard
    private let maxStoredSearches = 100
    
    // add a new search term to UserDefaults
    func addRecentSearch(text: String) {
        var recentSearchArray = [String]()
        if defaults.array(forKey: "Recent Search Array") != nil {
            recentSearchArray = defaults.array(forKey: "Recent Search Array") as! [String]
        }
        
        // remove case-insensitive duplicate element if it's already inside the array
        if let duplicateIndex = recentSearchArray.index(where: {$0.caseInsensitiveCompare(text) == .orderedSame}) {
            recentSearchArray.remove(at: duplicateIndex)
        }
        
        recentSearchArray.insert(text, at: 0)
        
        // remove oldest search if the number of stored searches > maximum value
        if recentSearchArray.count > maxStoredSearches {
            recentSearchArray.removeLast()
        }
        
        defaults.set(recentSearchArray, forKey: "Recent Search Array")
    }
    
    // return requested search term in a specific row
    func getRecentSearch(row index: Int) -> String? {
        var recentSearchArray = [String]()
        if defaults.array(forKey: "Recent Search Array") != nil {
            recentSearchArray = defaults.array(forKey: "Recent Search Array") as! [String]
            return recentSearchArray[index]
        }
        return nil
    }
    
    // get number of recent search terms
    func getCount() -> Int {
        var recentSearchArray = [String]()
        if defaults.array(forKey: "Recent Search Array") != nil {
            recentSearchArray = defaults.array(forKey: "Recent Search Array") as! [String]
            return recentSearchArray.count
        }
        return 0
    }
}
