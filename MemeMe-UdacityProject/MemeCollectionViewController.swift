//
//  MemeCollectionViewController.swift
//  MemeMe-UdacityProject
//
//  Created by Brian on 8/12/15.
//  Copyright (c) 2015 Rainien.com, LLC. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    var memes: [MemeStruct]!
    var chosenMeme: MemeStruct = MemeStruct()
    
    var newOne = true
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes

        clearsSelectionOnViewWillAppear = false

        // Register cell classes
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "MemeCollectionCell")

        let space: CGFloat = 3.0
        let wide = (view.frame.size.width - (2 * space)) / 3.0
        let tall = (collectionView!.frame.size.height - (10)) / 4.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSizeMake(wide, tall)
        
        flowLayout.minimumLineSpacing = space + 3
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! UICollectionViewCell
        
        let meme = memes[indexPath.item]
        
        cell.backgroundView = UIImageView(image: meme.generImage!)
        cell.backgroundView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }

    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        newOne = true
        performSegueWithIdentifier("collMemeSegue", sender: self)
    }


    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        chosenMeme = memes[indexPath.row]
        newOne = false
        performSegueWithIdentifier("collSegueView", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "collSegueView" {
            let viewVC = segue.destinationViewController as! MemeViewController
            viewVC.meme = chosenMeme
            viewVC.memeIndex = (sender as! NSIndexPath).row
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        collectionView?.reloadData()
        
        tabBarController?.tabBar.hidden = false
        tabBarController?.tabBar.frame.size.height = 49.0
    }
}
