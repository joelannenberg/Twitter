//
//  TweetDetailViewController.swift
//  Tweety
//
//  Created by Joel Annenberg on 3/12/16.
//  Copyright © 2016 Joel A. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet!
    
    let client = TwitterClient.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Custom format date string
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M/d/yy, hh:mm a"
        let dateString = formatter.stringFromDate(tweet.timestamp!)
        
        profileImageView.setImageWithURL(tweet.profileImageUrl!)
        nameLabel.text = tweet.name as? String
        handleLabel.text = "@\(tweet.handle as! String)"
        tweetText.text = tweet.text as? String
        timestamp.text = dateString
        retweetCount.text = "\(tweet.retweetCount)"
        favoriteCount.text = "\(tweet.favoritesCount)"
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        replyButton.imageView?.image = UIImage(named: "reply-action_0")
        
        if tweet.retweeted {
            retweetButton.setImage(UIImage(named: "retweet-action-on-green"), forState: .Normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweet-action_default"), forState: .Normal)
        }
        
        if tweet.favorited {
            favoriteButton.setImage(UIImage(named: "like-action-on-red"), forState: .Normal)
        } else {
            favoriteButton.setImage(UIImage(named: "like-action-off"), forState: .Normal)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        retweetCount.text = "\(tweet.retweetCount)"
        favoriteCount.text = "\(tweet.favoritesCount)"
        
        replyButton.imageView?.image = UIImage(named: "reply-action_0")
        
        if tweet.retweeted {
            retweetButton.setImage(UIImage(named: "retweet-action-on-green"), forState: .Normal)
        } else {
            retweetButton.setImage(UIImage(named: "retweet-action_default"), forState: .Normal)
        }
        
        if tweet.favorited {
            favoriteButton.setImage(UIImage(named: "like-action-on-red"), forState: .Normal)
        } else {
            favoriteButton.setImage(UIImage(named: "like-action-off"), forState: .Normal)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onReply(sender: AnyObject) {
        
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if tweet.retweeted == false {
            tweet.retweetCount += 1
            tweet.retweeted = true
            client.retweet(tweet.tweetId!)
        } else if tweet.retweeted == true {
            tweet.retweetCount -= 1
            tweet.retweeted = false
            client.unRetweet(tweet.tweetId!)
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        if tweet.favorited == false {
            tweet.favoritesCount += 1
            tweet.favorited = true
            client.favorite(tweet.tweetId!)
        } else if tweet.favorited == true {
            tweet.favoritesCount -= 1
            tweet.favorited = false
            client.unFavorite(tweet.tweetId!)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "profileSegue" {
            
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.tweet = tweet
            
            print("Profile segue preparation called")
        }
    }
    
}
