//
//  MemeViewController.swift
//  MemeMe-UdacityProject
//
//  Created by Brian on 8/20/15.
//  Copyright (c) 2015 Rainien.com, LLC. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {

    var meme: MemeStruct? = nil
    
    var memeIndex = 0
    
    @IBOutlet weak var imView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addRightNavItemOnView()
        imView.image = meme!.generImage!
        tabBarController?.tabBar.hidden = true
        tabBarController?.tabBar.frame.size.height = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func editButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("viewToEditSegue", sender: self)
    }
    
    func shareButtonPressed(sender: AnyObject) {
        let shareController = UIActivityViewController(activityItems: [meme!.generImage!], applicationActivities: nil)
        
        presentViewController(shareController, animated: true, completion: nil)
    }
    
    func addRightNavItemOnView() {
        
        let editButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        editButton.frame = CGRectMake(0, 0, 40, 40)
        editButton.setImage(UIImage(named:"Pencil"), forState: UIControlState.Normal)
        editButton.addTarget(self, action: "editButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        var rightBarButtonItemHome: UIBarButtonItem = UIBarButtonItem(customView: editButton)
        
        let buttonAction: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        buttonAction.frame = CGRectMake(0, 0, 40, 40)
        buttonAction.setImage(UIImage(named:"actionButton"), forState: UIControlState.Normal)
        buttonAction.addTarget(self, action: "shareButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var rightBarButtonItemAction: UIBarButtonItem = UIBarButtonItem(customView: buttonAction)
        
        navigationItem.setRightBarButtonItems([rightBarButtonItemAction, rightBarButtonItemHome], animated: true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewToEditSegue" {
            let editVC = segue.destinationViewController as! MemeEditViewController
            editVC.meme = meme
            editVC.memeIndex = memeIndex
        }
    }
}
