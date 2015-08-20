//
//  MemeEditViewController.swift
//  MemeMe-UdacityProject
//
//  Created by Brian on 8/16/15.
//  Copyright (c) 2015 Rainien.com, LLC. All rights reserved.
//

import UIKit
import CoreGraphics

class MemeEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var im: UIImage? = nil
    
    var meme: MemeStruct? = nil
    
    var memeIndex = 0
    
    var wasNew = true
    
    @IBOutlet weak var memeView: UIView!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBOutlet weak var bottomBarView: UIView!
    
    @IBOutlet weak var cameraButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Was given meme data from previous ViewController?
        if meme != nil {
            topTextField.text = meme!.topString
            bottomTextField.text = meme!.bottomString
            memeImageView.image = meme!.origImage
            
            adjustImageLayout(memeView.frame.size, imageSize: meme!.origImage!.size)
            wasNew = false
            
        } else {
            meme = MemeStruct()
        }
        
        // Set up textFilds
        let memeTextAttributes = [
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : -4.0,
            NSStrokeColorAttributeName : UIColor.blackColor()
        ]

        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.defaultTextAttributes = memeTextAttributes
        
        self.topTextField.textAlignment = NSTextAlignment.Center
        self.bottomTextField.textAlignment = NSTextAlignment.Center
        
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)

        self.tabBarController?.tabBar.hidden = true
        self.tabBarController?.tabBar.frame.size.height = 0.0
        self.subscribeToKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cameraButtonPressed(button: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func albumButtonPressed(button: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func actionButtonPressed(sender: UIBarButtonItem) {
        if (memeImageView.image != nil) {
            
            meme!.origImage = memeImageView.image
            meme!.topString = self.topTextField.text as String
            meme!.bottomString = self.bottomTextField.text as String
            meme!.generImage = generateMemedImage()
            
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            
            if wasNew {
                appDelegate.memes.append(meme!)
                self.memeIndex = appDelegate.memes.count - 1
                wasNew = false
            } else {
                appDelegate.memes[memeIndex] = meme!
            }
            
            self.performSegueWithIdentifier("showImage", sender: self)
            
        } else {
            showAlertWithText(header: "Meme Error", message: "To create a new Meme you must include one image.")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let imageChosen = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.memeImageView.image = imageChosen
            
            adjustImageLayout(self.memeView.frame.size, imageSize: memeImageView.image!.size)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            showAlertWithText(header: "File Type Error", message: "To create a Meme you must use a picture file.")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    // Keyboard control
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y = 0
        }
    }
    
    // textField Delegate Control
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.selectAll(true)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func generateMemedImage() -> UIImage {
        
        adjustImageLayout(memeView.frame.size, imageSize: memeImageView.image!.size)
        let origX: CGFloat = self.topTextField.frame.origin.x + 1
        let origY: CGFloat = self.topTextField.frame.origin.y + 1
        let frameWidth: CGFloat = self.topTextField.frame.width - 2
        let frameHeight: CGFloat = self.bottomTextField.frame.origin.y + 48 - origY

        var rect = CGRect()
        
        rect.origin = CGPoint(x: origX, y: origY)
        rect.size.width = frameWidth
        rect.size.height = frameHeight
        
        UIGraphicsBeginImageContext(self.memeView.bounds.size)
        self.memeView.drawViewHierarchyInRect(self.memeView.bounds, afterScreenUpdates: true)
        var memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        println(memedImage.size.width)
        println(memedImage.size.height)
        
        var imageRef: CGImageRef = CGImageCreateWithImageInRect(memedImage.CGImage, rect)
        
        memedImage = UIImage(CGImage: imageRef)!
        
        return memedImage
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImage" {
            let saveImVC: SavedViewController = segue.destinationViewController as! SavedViewController
            saveImVC.meme = self.meme!.generImage!
        }
    }
    
    func adjustImageLayout(memeViewSize: CGSize, imageSize: CGSize) {  //memeImageView.image must exist
        let widthRatio = memeViewSize.width/imageSize.width
        let heightRatio = memeViewSize.height/imageSize.height

        if (heightRatio > widthRatio) {
            //Picture presents shorter than view height
            self.topTextField.frame.size.width = memeViewSize.width
            self.bottomTextField.frame.size.width = memeViewSize.width
            
            self.topTextField.frame.origin.y = (memeViewSize.height - imageSize.height * widthRatio) / 2.0

            self.bottomTextField.frame.origin.y = memeViewSize.height - 50.0 - (memeViewSize.height - imageSize.height * widthRatio) / 2.0
            
            self.topTextField.frame.origin.x = 0.0
            self.bottomTextField.frame.origin.x = 0.0

        } else {
            //Picture presents narrower than view width
            self.topTextField.frame.size.width = imageSize.width * heightRatio
            self.bottomTextField.frame.size.width = imageSize.width * heightRatio
            
            self.topTextField.frame.origin.y = 0.0
            self.bottomTextField.frame.origin.y = memeViewSize.height - 50.0
            
            self.topTextField.frame.origin.x = (memeViewSize.width - imageSize.width * heightRatio) / 2.0
            self.bottomTextField.frame.origin.x = (memeViewSize.width - imageSize.width * heightRatio) / 2.0
        }
    }
    
    func showAlertWithText (header : String = "Warning", message : String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if self.memeImageView.image != nil {
            adjustImageLayout(self.memeView.frame.size, imageSize: memeImageView.image!.size)
        }
    }

}
