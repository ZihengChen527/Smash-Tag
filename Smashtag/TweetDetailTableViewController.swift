//
//  TweetDetailTableViewController.swift
//  Smashtag
//
//  Created by Ziheng Chen on 2/12/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailTableViewController: UITableViewController {

    // Mark: - Model
    
    private enum TweetDetail {
        case image(MediaItem)
        case hashtag(Mention)
        case url(Mention)
        case mentionedUser(Mention)

        var type: String {
            switch self {
            case .image:
                return "Images"
            case .hashtag:
                return "Hashtags"
            case .url:
                return "Urls"
            case .mentionedUser:
                return "Mentioned Users"
            }
        }
    }
    
    private var tweetDetailArray = [Array<TweetDetail>]()
    
    
    // Mark: - Public API
    
    func addTweetDetail(tweet: Twitter.Tweet) {

        if tweet.media.count > 0 {
            var imageSection = [TweetDetail]()
            for imageInTweet in tweet.media {
                imageSection.append(TweetDetail.image(imageInTweet))
            }
            tweetDetailArray.append(imageSection)
        }
        
        if tweet.hashtags.count > 0 {
            var hashtagSection = [TweetDetail]()
            for hashtagInTweet in tweet.hashtags {
                hashtagSection.append(TweetDetail.hashtag(hashtagInTweet))
            }
            tweetDetailArray.append(hashtagSection)
        }
        
        if tweet.urls.count > 0 {
            var urlSection = [TweetDetail]()
            for urlInTweet in tweet.urls {
                urlSection.append(TweetDetail.url(urlInTweet))
            }
            tweetDetailArray.append(urlSection)
        }
        
        if tweet.userMentions.count > 0 {
            var mentionedUserSection = [TweetDetail]()
            for userMentionInTweet in tweet.userMentions {
                mentionedUserSection.append(TweetDetail.mentionedUser(userMentionInTweet))
            }
            tweetDetailArray.append(mentionedUserSection)
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweetDetailArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetDetailArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tweetDetailArray[section].first?.type
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweetDetail = tweetDetailArray[indexPath.section][indexPath.row]
        switch tweetDetail {
        case .image(let mediaItem):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Images", for: indexPath)
            if let tweetDetailCell = cell as? TweetImageTableViewCell {
                tweetDetailCell.imageInfo = mediaItem
            }
            return cell
        case .hashtag(let mention), .url(let mention), .mentionedUser(let mention):
            let cell = tableView.dequeueReusableCell(withIdentifier: "Mentions", for: indexPath)
            cell.textLabel?.text = mention.keyword
            return cell
        }
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tweetDetail = tweetDetailArray[indexPath.section][indexPath.row]
        switch tweetDetail {
        case .image(let mediaItem):
            return view.bounds.width / CGFloat(mediaItem.aspectRatio)
        default:
            return UITableViewAutomaticDimension
        }
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fetch" {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell), let destinationController = segue.destination as? TweetTableViewController {
                let tweetDetail = tweetDetailArray[indexPath.section][indexPath.row]
                switch tweetDetail {
                case .hashtag(let mention), .mentionedUser(let mention):
                    destinationController.searchText = mention.keyword
                case .url(let mention):
                    UIApplication.shared.openURL(URL(string: mention.keyword)!)
                default:
                    break
                }
            }
        } else if segue.identifier == "scroll image" {
            if let cell = sender as? TweetImageTableViewCell, let indexPath = tableView.indexPath(for: cell), let destinationController = segue.destination as? ImageViewController {
                let tweetDetail = tweetDetailArray[indexPath.section][indexPath.row]
                switch tweetDetail {
                case .image(let mediaItem):
                    destinationController.imageURL = mediaItem.url
                    destinationController.aspectRatio = mediaItem.aspectRatio
                default:
                    break
                }
            }
        }
    }
}
