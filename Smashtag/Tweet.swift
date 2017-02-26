//
//  Tweet.swift
//  Smashtag
//
//  Created by Ziheng Chen on 2/20/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class Tweet: NSManagedObject {
    
    class func findOrCreateTweet(matching twitterInfo: Twitter.Tweet, with searchText: String, in context: NSManagedObjectContext) throws -> Tweet {
        
        // search if there is a matched existed tweet in the database
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.identifier)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Tweet.findOrCreateTweet -- database inconsistency")
                
                // check if the same search term is duplicate
                var duplicateSearchTweet = false
                for recentSearchIndex in 0..<RecentsDatabase().getCount() {
                    if searchText == RecentsDatabase().getRecentSearch(row: recentSearchIndex)! {
                        duplicateSearchTweet = true
                        break
                    }
                }
                
                // if the search term is not duplicate, add to the core data
                if (duplicateSearchTweet == false) {
                    for mention in twitterInfo.hashtags {
                        try? matches[0].addToMentions(Mention.findOrCreateMention(matching: mention, with: searchText, in: context))
                    }
                    for mention in twitterInfo.userMentions {
                        try? matches[0].addToMentions(Mention.findOrCreateMention(matching: mention, with: searchText, in: context))
                    }
                }
                
                return matches[0]
            }
        } catch {
            throw error
        }
        
        // if there is no existed tweet in core data, create a new one
        let tweet = Tweet(context: context)
        tweet.unique = twitterInfo.identifier
        tweet.text = twitterInfo.text
        for mention in twitterInfo.hashtags {
            try? tweet.addToMentions(Mention.findOrCreateMention(matching: mention, with: searchText, in: context))
        }
        for mention in twitterInfo.userMentions {
            try? tweet.addToMentions(Mention.findOrCreateMention(matching: mention, with: searchText, in: context))
        }
        return tweet
    }
}
