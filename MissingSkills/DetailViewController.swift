//
//  DetailViewController.swift
//  HackdeOverheid
//
//  Created by Niels Pijpers on 26-01-15.
//  Copyright (c) 2015 UB-online. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameController: UILabel!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var nameString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.nameController.text = nameString;
    }
    
    func viewWillAppear() {
        navigationItem.title = "Count:"
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
