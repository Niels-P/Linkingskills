//
//  SecondViewController.swift
//  MissingSkills
//
//  Created by Niels Pijpers on 06-02-15.
//  Copyright (c) 2015 NielsP. All rights reserved.
//

import UIKit
import OAuthSwift

class connectSkillsController: UIViewController, NSXMLParserDelegate {
    
    @IBOutlet weak var activitiy: UIActivityIndicatorView!
    @IBOutlet weak var toplabel: UILabel!
    @IBOutlet weak var bottomlabel: UILabel!
    @IBOutlet weak var navigation: UINavigationBar!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(red: 44.0/255.0, green: 108.0/255.0, blue: 192.0/255.0, alpha: 1.0)
        navigation.hidden = true
        getJobId()
        super.viewDidLoad()
    }
    
    func getJobId() {
        var jobId = "";
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var query = PFQuery(className:"users")
        query.getObjectInBackgroundWithId(prefs.stringForKey("user")) {
            (user: PFObject!, error: NSError!) -> Void in
            if error != nil {
                println(error)
            } else {
                jobId = user.valueForKey("job") as String;
                println(jobId);
                self.getSkills(jobId);
            }
        }
    }
    
    func getSkills(jobid: String) {
        var query = PFQuery(className:"skills")
        query.whereKey("jobid", equalTo:jobid)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var requiredSkills = (object.valueForKey("skills") as NSArray) as NSMutableArray
                        self.getOwnSkills(requiredSkills)
                    }
                } else {
                    println("Nope");
                }
            } else {
                println("Error: \(error) \(error.userInfo!)")
            }
        }
    }
    
    func getOwnSkills(reqSkills: NSMutableArray ) {
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var Skills = prefs.arrayForKey("skills")
        
        compareSkills(reqSkills, mySkills: Skills!);
    }
    
    func compareSkills(jobSkills: NSMutableArray, mySkills: NSArray) {
        for(var i = 0; i < mySkills.count; i++) {
            if(jobSkills.containsObject(mySkills[i])) {
                println("Gevonden skill \(mySkills[i])");
                jobSkills.removeObject(mySkills[i]);
            }
        }
        
        shareResults(jobSkills)
    }
    
    func shareResults(skillsLeft: NSMutableArray) {
        if(skillsLeft.count > 0) {
            /*
             * Er zijn skills gevonden, dan willen we die weergeven, TOCH?!
            */
            
            self.view.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            navigation.hidden = false

        } else {
            /*
             * Als er geen skills zijn gevonden, WAT DAN?!
            */
            
            var refreshAlert = UIAlertController(title: "U beschikt over alle vaardigheden!", message: "Volgens onze gegevens beschikt u al over alle benodigde vaardigheden voor dit beroep, wilt u een ander beroep kiezen?", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Verander beroep", style: .Default, handler: { (action: UIAlertAction!) in
               self.performSegueWithIdentifier("chooseOther", sender: self)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Stop", style: .Default, handler: { (action: UIAlertAction!) in
                self.performSegueWithIdentifier("goBack", sender: self)
            }))
            
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
    }
    

    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}






