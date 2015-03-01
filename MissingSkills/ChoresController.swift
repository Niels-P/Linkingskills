//
//  FirstViewController.swift
//  MissingSkills
//
//  Created by Niels Pijpers on 06-02-15.
//  Copyright (c) 2015 NielsP. All rights reserved.
//

import UIKit
import OAuthSwift

class ChoresController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var loggedIn = 0;
    var arrayOfKarweitjes: [Karweitjes] = [Karweitjes]()
    @IBOutlet weak var myTableView: UITableView!

    
    override func viewDidLoad() {
        self.setKarweitjes()
        super.viewDidLoad()
        
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    override func viewDidAppear(animated: Bool) {
        self.performSegueWithIdentifier("goto_login", sender: self)
        //let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        /*
        let oauthswift = OAuth1Swift(
            consumerKey:    "77id0z47h7yy9p",
            consumerSecret: "qBtL6w7JWTZyFRb7",
            requestTokenUrl: "https://api.linkedin.com/uas/oauth/requestToken",
            authorizeUrl:    "https://api.linkedin.com/uas/oauth/authenticate",
            accessTokenUrl:  "https://api.linkedin.com/uas/oauth/accessToken"
        )
        
        var parameters =  Dictionary<String, AnyObject>()
        oauthswift.client.setUserDetails("e5fd7c9b-f82e-4912-8536-03694c307cdf", secret: "b7b2c0a3-9183-43ec-ba17-9edc4f958f9c", parameters: parameters)
        
        oauthswift.client.get("https://api.linkedin.com/v1/people/~:(skills,first-name,last-name,picture-url)", parameters: parameters,
            success: {
                data, response in
                println("PARAMETERS: \(parameters)");
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                println(parameters);
                println(dataString);
                var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                prefs.setInteger(1, forKey: "ISLOGIN")
                prefs.synchronize()
            }, failure: {(error:NSError!) -> Void in
                println(error)
        })*/
        
        super.viewWillAppear(false);
        UITabBar.appearance().backgroundColor = UIColor.yellowColor();
    }
    
    func setKarweitjes() {
        var karweitje1 = Karweitjes(name: "SEO Teksten schrijven", description: "Test 123Test\n1234");
        var karweitje2 = Karweitjes(name: "SEO Teksten", description: "Lorem Ipsum Test\n1234");
        arrayOfKarweitjes.append(karweitje1);
        arrayOfKarweitjes.append(karweitje2);
        println(arrayOfKarweitjes.count);
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfKarweitjes.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomCell = tableView.dequeueReusableCellWithIdentifier("Cell") as CustomCell
        let karweitje = arrayOfKarweitjes[indexPath.row]
        
        if(indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        } else {
            cell.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.05)
        }
        
        cell.setCell(karweitje.name, description: karweitje.description);
        println(karweitje.name);
        return cell;
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        println("test");
        if(editingStyle == UITableViewCellEditingStyle.Delete)
        {
            arrayOfKarweitjes.removeAtIndex(indexPath.row);
            self.myTableView.reloadData();
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let karweitje = arrayOfKarweitjes[indexPath.row]
        
        let detailedViewController: DetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as DetailViewController
        
        detailedViewController.nameString = karweitje.name;
        
        println("test");

        
        self.presentViewController(detailedViewController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

