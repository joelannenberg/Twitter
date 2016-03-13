//
//  ProfileViewController.swift
//  Tweety
//
//  Created by Joel Annenberg on 3/12/16.
//  Copyright © 2016 Joel A. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.setImageWithURL(tweet.profileImageUrl!)
        nameLabel.text = tweet.name as String?
        handleLabel.text = "@\(tweet.handle!)"
        tweetCountLabel.text = "\(tweet.tweetCount!)"
        followingCountLabel.text = "\(tweet.followingCount!)"
        followersCountLabel.text = "\(tweet.followersCount!)"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
