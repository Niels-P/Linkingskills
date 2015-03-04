//
//  JobsTableViewController.swift
//  MissingSkills
//
//  Created by Niels Pijpers on 03-03-15.
//  Copyright (c) 2015 NielsP. All rights reserved.
//

import UIKit

class JobsTableViewController: UITableViewController {
    var jobs = [Jobs]()
    var filteredJobs = [Jobs]()

    @IBOutlet weak var searchbar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var query = PFQuery(className:"jobs")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    self.jobs = [];
                    for object in objects {
                        self.jobs.append(Jobs(category: object.valueForKey("category") as String, name: object.valueForKey("name") as String, id: object.valueForKey("objectId") as String));
                        self.tableView.reloadData()
                    }
                } else {
                    println("Nope");
                }
            } else {
                println("Error: \(error) \(error.userInfo!)")
            }
        }
        
        // Reload the table
        self.tableView.contentInset = UIEdgeInsetsMake(10,0,0,0);
        searchbar.translucent = false;
        searchbar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0);

    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /*
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredJobs.count
        } else {
            return self.jobs.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        var job : Jobs
        // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
        if tableView == self.searchDisplayController!.searchResultsTableView {
            job = filteredJobs[indexPath.row]
        } else {
            job = jobs[indexPath.row]
        }
        
        // Configure the cell
        cell.textLabel!.text = job.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filteredJobs = self.jobs.filter({( job : Jobs) -> Bool in
            var categoryMatch = (scope == "All") || (job.category == scope)
            var stringMatch = job.name.rangeOfString(searchText)
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        let scopes = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
        let selectedScope = scopes[self.searchDisplayController!.searchBar.selectedScopeButtonIndex] as String
        self.filterContentForSearchText(searchString, scope: selectedScope)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!,
        shouldReloadTableForSearchScope searchOption: Int) -> Bool {
            let scope = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]
            self.filterContentForSearchText(self.searchDisplayController!.searchBar.text, scope: scope[searchOption])
            return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.goOn(tableView)
    }
    
    func goOn(sender: AnyObject!) {
        if sender as UITableView == self.searchDisplayController!.searchResultsTableView {
            let indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
            let destinationTitle = self.filteredJobs[indexPath.row].id
            
            /*
             * Safe job to profile
            */
            
            var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            var query = PFQuery(className:"users")
            query.getObjectInBackgroundWithId(prefs.stringForKey("user")) {
                (user: PFObject!, error: NSError!) -> Void in
                if error != nil {
                    println(error)
                } else {
                    user["job"] = destinationTitle
                    user.saveInBackground()
                    
                    self.performSegueWithIdentifier("getSkills", sender: self)
                }
            }
            
            
        } else {
            let indexPath = self.tableView.indexPathForSelectedRow()!
            let destinationTitle = self.jobs[indexPath.row].id
            
            /*
             * Safe job to profile
            */
            
            var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            var query = PFQuery(className:"users")
            query.getObjectInBackgroundWithId(prefs.stringForKey("user")) {
                (user: PFObject!, error: NSError!) -> Void in
                if error != nil {
                    println(error)
                } else {
                    user["job"] = destinationTitle
                    user.saveInBackground()
                    self.performSegueWithIdentifier("getSkills", sender: self)
                    
                }
            }
            
            
        }
    }
    

}
