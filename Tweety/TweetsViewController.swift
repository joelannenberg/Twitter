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
            self.tweets![indexPath!.row].retweetCount += 1
            tweet.retweeted = true
            client.retweet(tweet.tweetId!)
            tableView.reloadData()
        } else if tweet.retweeted == true {
            self.tweets![indexPath!.row].retweetCount -= 1
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
        
        if tweet.favorited == false{
            self.tweets![indexPath!.row].favoritesCount += 1
            tweet.favorited = true
            client.favorite(tweet.tweetId!)
            self.tableView.reloadData()
        } else if tweet.favorited == true{
            self.tweets![indexPath!.row].favoritesCount -= 1
            tweet.favorited = false
            client.unFavorite(tweet.tweetId!)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onReply(sender: AnyObject) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
