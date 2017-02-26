//
//  SmashTweetTableViewController.swift
//  Smashtag
//
//  Created by Ziheng Chen on 2/21/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetTableViewController: TweetTableViewController {
    
    // model
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        updateDatabase(with: newTweets)
    }
    
    private func updateDatabase(with tweets: [Twitter.Tweet]) {
        container?.performBackgroundTask {[weak self] context in
            if self?.searchText != nil {
                for twitterInfo in tweets {
                    _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, with: (self?.searchText)!, in: context)
                }
            }
            try? context.save()
        }
    }
}
