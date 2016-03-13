//
//  TweetsViewController.swift
//  Tweety
//
//  Created by Joel Annenberg on 3/1/16.
//  Copyright © 2016 Joel A. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    
    let client = TwitterClient.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        client.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        client.logout()
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetCell
        let indexPath = tableView.indexPathForCell(cell)
        let tweet = tweets[indexPath!.row]
        
        if tweet.retweeted == false {
            tweets![indexPath!.row].retweetCount += 1
            tweet.retweeted = true
            client.retweet(tweet.tweetId!)
            tableView.reloadData()
        } else if tweet.retweeted == true {
            tweets![indexPath!.row].retweetCount -= 1
            tweet.retweeted = false
            client.unRetweet(tweet.tweetId!)
            tableView.reloadData()
        }
        
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetCell
        let indexPath = tableView.indexPathForCell(cell)
        let tweet = tweets[indexPath!.row]
        
        if tweet.favorited == false {
            tweets![indexPath!.row].favoritesCount += 1
            tweet.favorited = true
            client.favorite(tweet.tweetId!)
            tableView.reloadData()
        } else if tweet.favorited == true {
            tweets![indexPath!.row].favoritesCount -= 1
            tweet.favorited = false
            client.unFavorite(tweet.tweetId!)
            tableView.reloadData()
        }
    }
    
    @IBAction func onReply(sender: AnyObject) {
        
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        client.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })

        // Hide the RefreshControl
        refreshControl.endRefreshing()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            
            let tweetDetailViewController = segue.destinationViewController as! TweetDetailViewController
            tweetDetailViewController.tweet = tweet
            
            print("Detail segue preparation called")
        }
        
        if segue.identifier == "composeSegue" {
            let profileUrl = User.currentUser?.profileUrl
            
            let composeViewController = segue.destinationViewController as! ComposeViewController
            composeViewController.profileUrl = profileUrl
            
            print("Compose segue preparation called")
        }
        
    }
    

}
