//
//  TweetCell.swift
//  Tweety
//
//  Created by Joel Annenberg on 3/4/16.
//  Copyright © 2016 Joel A. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    
    var tweet: Tweet! {
        didSet {
            
            // Custom format date string
            let formatter = NSDateFormatter()
            formatter.dateFormat = "M/d/yy, hh:mm a"
            let dateString = formatter.stringFromDate(tweet.timestamp!)
            
            thumbImage.setImageWithURL(tweet.profileImageUrl!)
            nameLabel.text = tweet.name as? String
            handleLabel.text = "@\(tweet.handle as! String)"
            tweetLabel.text = tweet.text as? String
            timeLabel.text = dateString
            retweetCountLabel.text = "\(tweet.retweetCount)"
            likeCountLabel.text = "\(tweet.favoritesCount)"
            
            replyButton.imageView?.image = UIImage(named: "reply-action_0")
            
            if tweet.retweeted {
                retweetButton.imageView?.image = UIImage(named: "retweet-action-on-green")
            } else {
                retweetButton.imageView?.image = UIImage(named: "retweet-action_default")
            }
            
            if tweet.favorited {
                favoriteButton.imageView?.image = UIImage(named: "like-action-on-red")
            } else {
                favoriteButton.imageView?.image = UIImage(named: "like-action-off")
            }
            
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImage.layer.cornerRadius = 5
        thumbImage.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
