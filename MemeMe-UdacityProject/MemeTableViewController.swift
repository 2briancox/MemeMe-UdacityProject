//
//  MemeTableViewController.swift
//  MemeMe-UdacityProject
//
//  Created by Brian on 8/12/15.
//  Copyright (c) 2015 Rainien.com, LLC. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    var memes: [MemeStruct]!
    var chosenMeme: MemeStruct = MemeStruct()
    
    var newOne = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // DataSource for tableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell", forIndexPath: indexPath) as! UITableViewCell

        cell.imageView?.image = memes[indexPath.row].generImage
        cell.textLabel?.text = memes[indexPath.row].topString
        cell.detailTextLabel?.text = memes[indexPath.row].bottomString
        
        return cell
    }

    // Delegate for tableView
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        chosenMeme = memes[indexPath.row]
        newOne = false
        performSegueWithIdentifier("tableSegueView", sender: self)
    }
    
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        newOne = true
        performSegueWithIdentifier("memeEditSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tableSegueView" {
            let editVC = segue.destinationViewController as! MemeViewController
            editVC.meme = chosenMeme
            editVC.memeIndex = tableView.indexPathForSelectedRow()!.row
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        tableView.reloadData()
        
        tabBarController?.tabBar.hidden = false
        tabBarController?.tabBar.frame.size.height = 49.0
        
    }

}
