//
//  ViewController.swift
//  OAuthSwift
//
//  Created by Dongri Jin on 6/21/14.
//  Copyright (c) 2014 Dongri Jin. All rights reserved.
//

import UIKit
import OAuthSwift

class LinkedinLoginController: UIViewController, NSXMLParserDelegate {
    let dataString = NSString();
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var voornaam = NSMutableString()
    var achternaam = NSMutableString()
    var skills = NSMutableArray()
    var imageurl = NSMutableString()
    
    @IBOutlet weak var doLink: UIButton!
    @IBAction func doLink(sender: AnyObject) {
        doOAuthLinkedin()
    }
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelProgress: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        self.doLink.hidden = true;
        super.viewDidLoad()
        doOAuthLinkedin()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func doOAuthLinkedin(){
        self.labelProgress.text = "";
        self.doLink.hidden = true;
        self.labelName.text = ""
        self.labelName.textColor = UIColor.whiteColor()
        self.labelProgress.textColor = UIColor.whiteColor()
        
        labelProgress.text = "Verbinden met LinkedIn";
        let oauthswift = OAuth1Swift(
            consumerKey:    "77id0z47h7yy9p",
            consumerSecret: "qBtL6w7JWTZyFRb7",
            requestTokenUrl: "https://api.linkedin.com/uas/oauth/requestToken",
            authorizeUrl:    "https://api.linkedin.com/uas/oauth/authenticate",
            accessTokenUrl:  "https://api.linkedin.com/uas/oauth/accessToken"
        )
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/linkedin")!, success: {
            credential, response in
            self.storeTokens("Linkedin", token: "\(credential.oauth_token)", secret: "\(credential.oauth_token_secret)")
            
            /*
            Reset labels etc.
            */
            self.doLink.hidden = true;
            self.labelName.hidden = true;
            self.labelProgress.hidden = true;
            self.indicator.hidden = false;
            
            self.labelProgress.text = "Even geduld AUB.";
            self.labelName.text = ""
            self.labelName.textColor = UIColor.whiteColor()
            self.labelProgress.textColor = UIColor.whiteColor()
            self.labelName.hidden = false;
            self.labelProgress.hidden = false;
            
            var parameters =  Dictionary<String, AnyObject>()
            oauthswift.client.get("https://api.linkedin.com/v1/people/~:(skills,first-name,last-name,picture-url)", parameters: parameters,
                success: {
                    data, response in
                    
                    let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println(parameters);
                    self.loginUser(dataString!);

                }, failure: {(error:NSError!) -> Void in
                    println(error)
            })
            }, failure: {(error:NSError!) -> Void in
                self.doLink.hidden = false;
                self.labelName.hidden = true;
                self.labelProgress.hidden = true;
                self.indicator.hidden = true;
                
                self.labelProgress.text = "Autorisatie opvragen mislukt.";
                self.labelName.text = "Fout opgetreden"
                self.labelName.textColor = UIColor.redColor()
                self.labelProgress.textColor = UIColor.redColor()
                self.labelName.hidden = false;
                self.labelProgress.hidden = false;
                println(error.localizedDescription)
                
        })
    }
    
    
    func storeTokens(title: String, token: String, secret: String) {
        var object = PFObject(className: "users")
        var uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
        object.addObject(uuid, forKey: "uuid")
        object.addObject(token, forKey: "oauth_token")
        object.addObject(secret, forKey: "oauth_toke_secret")
        object.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                var ojId = object.objectId
                var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                prefs.setValue(token, forKey: "token")
                prefs.setValue(ojId, forKey: "user");
                prefs.setValue(secret, forKey: "secret")
                prefs.synchronize()
            }}
    }
    
    func loginUser(data: String) {

        
        var mydata:NSData = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        posts = []
        var xmlParser = NSXMLParser(data: mydata)
        xmlParser.delegate = self
        xmlParser.parse()
        
        var voornaam = posts.objectAtIndex(0).valueForKey("voornaam") as NSString;
        var skills =  (posts.objectAtIndex(0).valueForKey("skills") as NSArray) as Array
        var achternaam = posts.objectAtIndex(0).valueForKey("achternaam") as NSString;
        
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setValue(skills, forKey: "skills")
        prefs.synchronize()
        
        labelName.text = "Hallo \(voornaam) \(achternaam)";
        labelProgress.text = "Profiel geladen...";
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("toChores", sender: self)
        }
        
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!)
    {
        element = elementName
        if (elementName as NSString).isEqualToString("item")
        {
            elements = NSMutableDictionary.alloc()
            elements = [:]
            voornaam = NSMutableString.alloc()
            voornaam = ""
            achternaam = NSMutableString.alloc()
            achternaam = ""
            imageurl = NSMutableString.alloc()
            imageurl = ""
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!)
    {
        if element.isEqualToString("first-name") {
            voornaam.appendString(string)
        } else if element.isEqualToString("last-name") {
            achternaam.appendString(string)
        } else if element.isEqualToString("name") {
            var string = string.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            if(string != "\n") {
                skills.addObject(string);
            }
            
        } else if(element.isEqualToString("picture-url")) {
            imageurl.appendString(string);
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!)
    {
        if (elementName as NSString).isEqualToString("person") {
            if !voornaam.isEqual(nil) {
                elements.setObject(voornaam, forKey: "voornaam")
            }
            if !achternaam.isEqual(nil) {
                elements.setObject(achternaam, forKey: "achternaam")
            }
            if !skills.isEqual(nil) {
                elements.setObject(skills, forKey: "skills");
            }
            if !imageurl.isEqual(nil) {
                elements.setObject(imageurl, forKey: "profileimage");
            }
            posts.addObject(elements)
        }
    }
    
    

    
    
}
