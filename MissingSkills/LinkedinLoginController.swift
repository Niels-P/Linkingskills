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
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelProgress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doOAuthLinkedin()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func doOAuthLinkedin(){
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
            println("Token BELANGRIJK: \(credential.oauth_token)");
            println("Secret BELANGRIJK: \(credential.oauth_token_secret)");
            var parameters =  Dictionary<String, AnyObject>()
            oauthswift.client.get("https://api.linkedin.com/v1/people/~:(skills,first-name,last-name,picture-url)", parameters: parameters,
                success: {
                    data, response in
                    println("PARAMETERS: \(parameters)");
                    let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println(parameters);
                    self.loginUser(dataString!);
                    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                    prefs.setInteger(1, forKey: "ISLOGIN")
                    prefs.synchronize()
                }, failure: {(error:NSError!) -> Void in
                    println(error)
            })
            }, failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
        })
    }
    
    
    func storeTokens(title: String, token: String, secret: String) {
        var object = PFObject(className: "users")
        var uuid = NSUUID().UUIDString
        object.addObject(uuid, forKey: "uuid")
        object.addObject(token, forKey: "oauth_token")
        object.addObject(secret, forKey: "oauth_toke_secret")
        object.save()
    }
    
    func loginUser(data: String) {
        var mydata:NSData = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        posts = []
        var xmlParser = NSXMLParser(data: mydata)
        xmlParser.delegate = self
        xmlParser.parse()
        
        var voornaam = posts.objectAtIndex(0).valueForKey("voornaam") as NSString;
        var achternaam = posts.objectAtIndex(0).valueForKey("achternaam") as NSString;
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
