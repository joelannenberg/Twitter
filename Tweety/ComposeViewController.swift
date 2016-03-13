//
//  ComposeViewController.swift
//  Tweety
//
//  Created by Joel Annenberg on 3/13/16.
//  Copyright © 2016 Joel A. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textBox: UITextView!
    
    var profileUrl: NSURL?
    let client = TwitterClient.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.setImageWithURL(profileUrl!)
        textBox.becomeFirstResponder()
        
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onX(sender: AnyObject) {
        textBox.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: {})
        print("Modal dismissed")
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        let startString = textBox.text
        let doneString = startString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        client.tweet(doneString!)
        
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
}
