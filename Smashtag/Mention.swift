//
//  Mention.swift
//  Smashtag
//
//  Created by Ziheng Chen on 2/20/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class Mention: NSManagedObject {
    
    static func findOrCreateMention(matching mentionInTweet: Twitter.Mention, with searchText: String, in context: NSManagedObjectContext) throws -> Mention {
        let request: NSFetchRequest<Mention> = Mention.fetchRequest()
        request.predicate = NSPredicate(format: "keyword ==[c] %@ and searchText ==[c] %@", mentionInTweet.keyword, searchText)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "TwitterUser.findOrCreateTwitterUser -- database inconsistency!")
                matches[0].count += 1
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let mention = Mention(context: context)
        let mentionKeyword = mentionInTweet.keyword
        mention.keyword = mentionKeyword
        mention.text = mentionInTweet.keyword[mentionKeyword.index(after: mentionKeyword.startIndex)..<mentionInTweet.keyword.endIndex]
        mention.count = 1
        mention.searchText = searchText
        return mention
    }
}
