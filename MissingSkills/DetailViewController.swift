//
//  DetailViewController.swift
//  HackdeOverheid
//
//  Created by Niels Pijpers on 26-01-15.
//  Copyright (c) 2015 UB-online. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var karweitjeNaam: UILabel!
    @IBOutlet weak var nameController: UILabel!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var diffIcon: UIImageView!
    @IBOutlet weak var coinsL: UILabel!
    @IBOutlet weak var deadlineL: UILabel!
    @IBOutlet weak var descri: UITextView!
    
    var nameString: String?
    var descrip: String?
    var coins: String?
    var grade: String?
    var deadline: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        karweitjeNaam.text = nameString;
        var test = String(grade!);
        switch(test) {
            case "hard":
                diffIcon.image = UIImage(named: "hard.png")
                break;
            case "medium":
                diffIcon.image = UIImage(named: "medium.png")
                break;
            case "easy":
                diffIcon.image = UIImage(named: "easy.png")
                break;
        default:
            break;
        }
        coinsL.text = coins;
        deadlineL.text = deadline;
        descri.text = descrip
        self.navigationItem.title = "Count:"
        self.navigationController?.navigationBar.topItem?.title = "Home"
    }
    
    func viewWillAppear() {
        self.navigationItem.title = "Count:"
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
