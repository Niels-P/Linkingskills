//
//  SecondViewController.swift
//  MissingSkills
//
//  Created by Niels Pijpers on 06-02-15.
//  Copyright (c) 2015 NielsP. All rights reserved.
//

import UIKit
import OAuthSwift

class connectSkillsController: UIViewController, NSXMLParserDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var activitiy: UIActivityIndicatorView!
    @IBOutlet weak var toplabel: UILabel!
    @IBOutlet weak var bottomlabel: UILabel!
    @IBOutlet weak var navigation: UINavigationBar!
    @IBOutlet weak var textExplain: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomBar: UIToolbar!
    
    var items: [String] = []
    var notItems: [String] = []

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    @IBAction func go(sender: AnyObject) {
        tableView.hidden = true;
        navigation.hidden = true;
        textExplain.hidden = true;
        bottomBar.hidden = true;
        
        self.view.backgroundColor = UIColor(red: 44.0/255.0, green: 108.0/255.0, blue: 192.0/255.0, alpha: 1.0)
        toplabel.text = "Klusjes aan het verzamelen";
        bottomlabel.hidden = false;
        toplabel.hidden = false;
        activitiy.hidden = false;
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("someSelector"), userInfo: nil, repeats: false)
    }
    
    func someSelector() {
        self.performSegueWithIdentifier("goChores", sender: self)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        println(items);
        var textual = self.items[indexPath.row];
        cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        cell.textLabel?.text = self.items[indexPath.row]
        if(textual[textual.startIndex] == "1") {
            cell.textLabel?.text = textual.stringByReplacingOccurrencesOfString("1", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            cell.imageView?.image = UIImage(named: "vink.png");
        } else {
            cell.imageView?.image = UIImage(named: "delete.png");
        }
        return cell
    }
    
    
    
    override func viewDidLoad() {
        textExplain.hidden = true;
        tableView.hidden = true;
        bottomBar.hidden = true;
        navigation.hidden = true

        
        self.view.backgroundColor = UIColor(red: 44.0/255.0, green: 108.0/255.0, blue: 192.0/255.0, alpha: 1.0)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.separatorColor = UIColor.whiteColor()
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
        for(var i = 0; i < jobSkills.count; i++) {
            if(mySkills.containsObject(jobSkills[i])) {
                println("Gevonden skill \(jobSkills[i])");
                items.append("1\(jobSkills[i])");
                
            } else {
                items.append("\(jobSkills[i])");
                notItems.append("\(jobSkills[i])");
            }
        }
        self.tableView.reloadData()
        shareResults(jobSkills)
    }
    
    func shareResults(skillsLeft: NSMutableArray) {
        if(notItems.count > 0) {
            /*
             * Er zijn skills gevonden, dan willen we die weergeven, TOCH?!
            */
            
            var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            var query = PFQuery(className:"users")
            println(prefs.stringForKey("user"))
            query.getObjectInBackgroundWithId(prefs.stringForKey("user")) {
                (user: PFObject!, error: NSError!) -> Void in
                if error != nil {
                    println(error)
                } else {
                    user["missingSkills"] = self.notItems
                    user.saveInBackground()
                }
            }
            
            self.view.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            
            textExplain.hidden = false;
            navigation.hidden = false
            tableView.hidden = false;
            bottomBar.hidden = false;
            

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






