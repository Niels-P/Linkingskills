//
//  FirstViewController.swift
//  MissingSkills
//
//  Created by Niels Pijpers on 06-02-15.
//  Copyright (c) 2015 NielsP. All rights reserved.
//

import UIKit

class defaultController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    @IBAction func declinePolicy(sender: AnyObject) {
        /*
         * Is being apply'd once the user clicks on decline.
        */
        self.performSegueWithIdentifier("backToIntro", sender: self);
        let alert = UIAlertView()
        alert.title = "Algemene voorwaarden geweigerd"
        alert.message = "U heeft de algemene voorwaarden geweigerd. U moet deze accepteren om de app te gebruiken. U word terug gestuurd naar het begin scherm."
        alert.addButtonWithTitle("Ik begrijp het")
        alert.show()
        
    }
    
    @IBAction func acceptPolicy(sender: AnyObject) {
        /*
         * Is being apply'd once the user clicks on accepts.
        */
        var refreshAlert = UIAlertController(title: "Weet je het zeker?", message: "Weet je het zeker dat je de algemene voorwaarden wil accepteren?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Accepteer", style: .Default, handler: { (action: UIAlertAction!) in
            
            var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()            
            var query = PFQuery(className:"users")
            println(prefs.stringForKey("user"))
            query.getObjectInBackgroundWithId(prefs.stringForKey("user")) {
                (user: PFObject!, error: NSError!) -> Void in
                if error != nil {
                    println(error)
                } else {
                    user["acceptedl"] = 1
                    user.saveInBackground()
                }
            }

            
            self.performSegueWithIdentifier("goOn", sender: self)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Annuleren", style: .Default, handler: { (action: UIAlertAction!) in
            /*
             * User cancled the agreement by the check.
            */
            
            println("User cancled the action.")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

