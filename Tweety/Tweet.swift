//
//  Tweet.swift
//  Tweety
//
//  Created by Joel Annenberg on 2/28/16.
//  Copyright © 2016 Joel A. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var profileImageUrl: NSURL?
    var name: NSString?
    var handle: NSString?
    var tweetId: String?
    var retweeted: Bool
    var favorited: Bool
    
    init(dictionary: NSDictionary) {
        let user = dictionary["user"] as? NSDictionary
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        tweetId = dictionary["id_str"] as? String
        name = user!["name"] as? String
        handle = user!["screen_name"] as? String
        retweeted = dictionary["retweeted"] as! Bool
        favorited = dictionary["favorited"] as! Bool
        
        let profileImageUrlString = user!["profile_image_url_https"] as? String
        if profileImageUrlString != nil {
            profileImageUrl = NSURL(string: profileImageUrlString!)!
        } else {
            profileImageUrl = nil
        }
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
            
        }
    }
    
    class func tweetsWithArray (dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
