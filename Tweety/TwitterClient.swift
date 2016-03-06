//
//  TwitterClient.swift
//  Tweety
//
//  Created by Joel Annenberg on 2/29/16.
//  Copyright © 2016 Joel A. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "OVNStym73KioFXgUwosFSvwcM", consumerSecret: "qtw9I87lBfWVQFjCW92KEV6RykNDde51IdGdQrS27wGswjZZh6")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "tweety://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
        }) { (error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                self.loginFailure?(error)
            })
            
            self.loginSuccess?()
            
        }) { (error: NSError!) -> Void in
            print(error.localizedDescription)
            self.loginFailure?(error)
        }
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)

        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            
            failure(error)
        })
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    // Tweet actions:
    func tweet(tweetText: String) {
        POST("1.1/statuses/update.json?status=\(tweetText)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response:AnyObject?) -> Void in
            print("Tweet success")
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            print(error.localizedDescription)
        })
    }
    
    func retweet(tweetId: String) {
        POST("1.1/statuses/retweet/\(tweetId).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Retweet success")
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            print(error.localizedDescription)
        })
    }
    
    func unRetweet(tweetId: String) {
        POST("1.1/statuses/unretweet/\(tweetId).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("Unretweet success")
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            print(error.localizedDescription)
        })
    }
    
    func favorite(tweetId: String) {
        POST("1.1/favorites/create.json?id=\(tweetId)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response:AnyObject?) -> Void in
            print("Favorite success")
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            print(error.localizedDescription)
        })
    }
    
    func unFavorite(tweetId: String) {
        POST("1.1/favorites/destroy.json?id=\(tweetId)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response:AnyObject?) -> Void in
            print("Unfavorite success")
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            print(error.localizedDescription)
        })
    }
    
}