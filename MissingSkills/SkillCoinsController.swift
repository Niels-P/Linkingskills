//
//  SecondViewController.swift
//  MissingSkills
//
//  Created by Niels Pijpers on 06-02-15.
//  Copyright (c) 2015 NielsP. All rights reserved.
//

import UIKit
import OAuthSwift

class SkillCoinsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var skillCAmount: UILabel!
    
    var apps: [String] = []
    var total:Int = 0;
    var createdAts: [String] = []
    
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
        
        oauthswift.client.get("https://api.linkedin.com/v1/people/~:(picture-url,first-name,last-name)", parameters: parameters,
            success: {
                data, response in
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                var imageURL = self.parse(dataString!, open:
                    "<picture-url>", close: "</picture-url>");
                var firstname = self.parse(dataString!, open:
                    "<first-name>", close: "</first-name>");
                var lastname = self.parse(dataString!, open:
                    "<last-name>", close: "</last-name>");
                
                
                var query = PFQuery(className:"users")
                query.getObjectInBackgroundWithId(prefs.stringForKey("user")) {
                    (user: PFObject!, error: NSError!) -> Void in
                    if error != nil {
                        println(error)
                    } else {
                        user["firstname"] = firstname as String
                        user["lastname"] = lastname as String
                        
                        user.saveInBackground();
                    }
                }
                
                self.fullName.text = "\(firstname) \(lastname)"

                
                let url = NSURL(string: imageURL)
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                self.imageAvatar.image = UIImage(data: data!)
                self.imageAvatar.layer.cornerRadius = self.imageAvatar.frame.size.width / 6;
                self.imageAvatar.clipsToBounds = true;


            }, failure: {(error:NSError!) -> Void in
                println(error)
        })

        var twoquery = PFQuery(className:"coins")
        twoquery.whereKey("userid", equalTo:prefs.stringForKey("user"))
        twoquery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var coins: AnyObject? =  object.valueForKey("coins");
                        var coin = "\(coins!)"
                        var createdAt: AnyObject? =  object.valueForKey("createdAt");
                        var created = "\(createdAt!)"


                        self.apps.append("\(coin)")
                        self.createdAts.append("\(created)")
                        self.tableView.reloadData();
                        
                        
                    }
                    
                    println(self.apps)
                    for app in self.apps {
                        println(app);
                        var add = app.toInt()
                        self.total = self.total + add!
                    }
                    self.skillCAmount.text = String(self.total)
                    
                } else {
                    println("Nope");
                }
            } else {
                println("Error: \(error) \(error.userInfo!)")
            }
        }
        
        
        
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // 1
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 2
        return apps.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 3
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = "+ \(apps[indexPath.row]) skillcoins"
        cell.detailTextLabel?.text = createdAts[indexPath.row]
        
        return cell
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