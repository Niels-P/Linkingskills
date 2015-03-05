//
//  SecondViewController.swift
//  MissingSkills
//
//  Created by Niels Pijpers on 06-02-15.
//  Copyright (c) 2015 NielsP. All rights reserved.
//

import UIKit
import OAuthSwift

class SkillCoinsController: UIViewController {
    
    @IBOutlet weak var imageAvatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAvatar();
    }
    
    func setAvatar() {
        
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let oauthswift = OAuth1Swift(
            consumerKey:    "77id0z47h7yy9p",
            consumerSecret: "qBtL6w7JWTZyFRb7",
            requestTokenUrl: "https://api.linkedin.com/uas/oauth/requestToken",
            authorizeUrl:    "https://api.linkedin.com/uas/oauth/authenticate",
            accessTokenUrl:  "https://api.linkedin.com/uas/oauth/accessToken"
        )
        
        var parameters =  Dictionary<String, AnyObject>()
        oauthswift.client.setUserDetails(prefs.stringForKey("token")!, secret: prefs.stringForKey("secret")!, parameters: parameters)
        
        oauthswift.client.get("https://api.linkedin.com/v1/people/~:(picture-url)", parameters: parameters,
            success: {
                data, response in
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                var imageURL = self.parse(dataString!, open: "<picture-url>", close: "</picture-url>");
                
                let url = NSURL(string: imageURL)
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                self.imageAvatar.image = UIImage(data: data!)
                self.imageAvatar.layer.cornerRadius = self.imageAvatar.frame.size.width / 6;
                self.imageAvatar.clipsToBounds = true;


            }, failure: {(error:NSError!) -> Void in
                println(error)
        })
        
    }
    
    func parse(thing: NSString, open: NSString, close: NSString ) -> NSString
    {
        var divRange:NSRange = thing.rangeOfString(open, options:NSStringCompareOptions.CaseInsensitiveSearch);
        if (divRange.location != NSNotFound)
        {
            var endDivRange = NSMakeRange(divRange.length + divRange.location, thing.length - ( divRange.length + divRange.location))
            endDivRange = thing.rangeOfString(close, options:NSStringCompareOptions.CaseInsensitiveSearch, range:endDivRange);
            
            if (endDivRange.location != NSNotFound)
            {
                divRange.location += divRange.length;
                divRange.length  = endDivRange.location - divRange.location;
            }
        }
        return thing.substringWithRange(divRange);
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition
    {
        return .TopAttached
    }
    
    
}