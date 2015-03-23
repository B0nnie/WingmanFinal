//
//  ViewController.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/1/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var gravityBehavior: UIGravityBehavior!
    var snapBehavior: UISnapBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: view)
        
        self.logoImageView.layer.cornerRadius = 50
        self.logoImageView.clipsToBounds = true
    
        //hides navigation bar on LoginVC
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        //sets navigation bar to a clear black color
         self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        //sets navigation bar's "Back" button item to white
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    
    }
    
    
    override func viewDidAppear(animated: Bool) {
        self.logoImageView.layer.cornerRadius = 50
         self.logoImageView.clipsToBounds = true
        
        
//        springWithDelay(0.5, 0.05, {
//            self.logoImageView.transform = CGAffineTransformMakeTranslation(0, 0)
//        })
        

        if PFUser.currentUser() != nil {
            
            var tbc = storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
            
            tbc?.tabBar.tintColor = UIColor.whiteColor()

            
            tbc?.tabBar.barStyle = UIBarStyle.Black
            
            println(tbc)
            
            UIApplication.sharedApplication().keyWindow?.rootViewController = tbc
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
         self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        
        
    }
    
    @IBOutlet weak var usernameField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func loginButton(sender: AnyObject) {
        
        self.usernameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        
        var fieldValues: [String] = [usernameField.text, passwordField.text]
        
        if find(fieldValues, "") != nil {
            
            //all fields are not filled in
            var alertViewController = UIAlertController(title: "Submission Error", message: "Please complete all fields", preferredStyle: UIAlertControllerStyle.Alert)
            
            var defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alertViewController.addAction(defaultAction)
            
            presentViewController(alertViewController, animated: true, completion: nil)
        }
            
    
        
        else {
            
            PFUser.logInWithUsernameInBackground(usernameField.text, password:passwordField.text) {
                (user: PFUser!, error: NSError!) -> Void in
                
                
                if (user != nil) {
                    // need to go to tabBarController
                    
                    
                    
                    //all fields are filled in
                    println("All fields are filled in and login complete")
                    
                    
                    var userQuery = PFUser.query()
                    userQuery.whereKey("username", equalTo: self.usernameField.text)
                    
                    userQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                        
                        if objects.count > 0 {
                            
                            self.isLoggedIn = true
                            self.checkIfLoggedIn()
                            
                        } else {
                            
//                            self.signUp()
                        }
                    })
                    
                } else {
                    if let errorString = error.userInfo?["error"] as? NSString
                    {
                        var alert:UIAlertView = UIAlertView(title: "Error", message: errorString, delegate: nil, cancelButtonTitle: "Ok")
                        
                        alert.show()
                    }
                        
                    else {
                        var alert:UIAlertView = UIAlertView(title: "Error", message: "Unable to login" , delegate: nil, cancelButtonTitle: "Ok")
                        
                        alert.show()
                        
                    }
                    
                    
                    
                }
                
            
            }
        }
    }

    
    var isLoggedIn: Bool {
        
        get {
            
            return NSUserDefaults.standardUserDefaults().boolForKey("isLoggedIn")
            
        }
        
        set {
            
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "isLoggedIn")
            
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
    }
        

    func checkIfLoggedIn(){
        
        println(isLoggedIn)
        
        if isLoggedIn {
            
            //replace this controller with the tabbarcontroller
            
            
            
            
            
            var tbc = storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as? UITabBarController
            
            tbc?.tabBar.tintColor = UIColor.whiteColor()
            
            
            tbc?.tabBar.barStyle = UIBarStyle.Black
            
            println(tbc)
            
            UIApplication.sharedApplication().keyWindow?.rootViewController = tbc
        }
        
        
    }

  
  
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

