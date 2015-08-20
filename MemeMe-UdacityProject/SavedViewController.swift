//
//  SavedViewController.swift
//  MemeMe-UdacityProject
//
//  Created by Brian on 8/17/15.
//  Copyright (c) 2015 Rainien.com, LLC. All rights reserved.
//

import UIKit

class SavedViewController: UIViewController {

    var meme: UIImage = UIImage()
    
    @IBOutlet weak var imView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imView.image = meme
        self.addRightNavItemOnView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    func homeButtonPressed(sender: AnyObject) {
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    func shareButtonPressed(sender: AnyObject) {
            let nextController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
            
            self.presentViewController(nextController, animated: true, completion: nil)
    }
    
    func addRightNavItemOnView() {
        
        let homeButton: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        homeButton.frame = CGRectMake(0, 0, 40, 40)
        homeButton.setImage(UIImage(named:"Home"), forState: UIControlState.Normal)
        homeButton.addTarget(self, action: "homeButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonItemHome: UIBarButtonItem = UIBarButtonItem(customView: homeButton)
        
        let buttonAction: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonAction.frame = CGRectMake(0, 0, 40, 40)
        buttonAction.setImage(UIImage(named:"actionButton"), forState: UIControlState.Normal)
        buttonAction.addTarget(self, action: "shareButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var rightBarButtonItemAction: UIBarButtonItem = UIBarButtonItem(customView: buttonAction)
        
        self.navigationItem.setRightBarButtonItems([rightBarButtonItemAction, rightBarButtonItemHome], animated: true)
        
    }
}
