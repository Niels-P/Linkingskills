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
    var arrayOfKarweitjes: [Karweitjes] = [Karweitjes]()
    @IBOutlet weak var myTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        myTableView.separatorInset = UIEdgeInsetsZero

    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition
    {
        return .TopAttached
    }
    
    

    
    override func viewDidAppear(animated: Bool) {
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()

        if(prefs.stringForKey("token") != nil || prefs.stringForKey("secret") != nil ) {
            println(prefs.stringForKey("token"))
            println(prefs.stringForKey("secret"))
            self.arrayOfKarweitjes.removeAll()
            startController();
        } else {
            self.performSegueWithIdentifier("goto_login", sender: self)
        }
        
        super.viewWillAppear(false);
        UITabBar.appearance().backgroundColor = UIColor.yellowColor();
    }
    
    func startController() {
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var query = PFQuery(className:"users")
        query.getObjectInBackgroundWithId(prefs.stringForKey("user")) {
            (user: PFObject!, error: NSError!) -> Void in
            if error != nil {
                println(error)
            } else {
                var filterSkills = (user.valueForKey("missingSkills") as NSArray) as NSMutableArray
                self.choresSelector(filterSkills);
                self.performSegueWithIdentifier("getSkills", sender: self)
            }
        }
    }
    
    func choresSelector(filterSkills : NSArray) {
        var query = PFQuery(className:"chores")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        if(object.valueForKey("userid") == nil)
                        {
                            var arraySkills = (object.valueForKey("skills") as NSArray) as NSMutableArray
                            for skills in filterSkills {
                                if(arraySkills.containsObject(skills)) {
                                    var name = object.valueForKey("name") as String
                                    var descrip = object.valueForKey("descr") as String
                                    var coins: AnyObject? =  object.valueForKey("coins");
                                    var deadline: AnyObject? =  object.valueForKey("deadline");
                                    var difficulty: AnyObject? =  object.valueForKey("grade");
                                    var deadl = "\(deadline!)"
                                    println(deadl);
                                    var coin:String = "\(coins!)"
                                    var grade = "\(difficulty!)"
                                    
                                    
                                    var karweitje = Karweitjes(name: name, description: descrip, coins: coin, deadline: deadl, grade: grade);
                                    self.arrayOfKarweitjes.append(karweitje);
                                    self.myTableView.reloadData();
                                }
                            }
                        }
                    }
                } else {
                    println("Nope");
                }
            } else {
                println("Error: \(error) \(error.userInfo!)")
            }
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfKarweitjes.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : CustomCell = tableView.dequeueReusableCellWithIdentifier("Cell") as CustomCell
        let karweitje = arrayOfKarweitjes[indexPath.row]
        cell.frame=CGRectMake(44,0,tableView.bounds.size.width,44)
        if(indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
            
        } else {
            cell.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        }
        
        cell.setCell(karweitje.name, description: karweitje.description, coins: karweitje.coins, deadline: karweitje.deadline, grade: karweitje.grade);
        println(karweitje.name);
        return cell;
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
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

