//
//  BrowseTableViewController.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/3/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit

class BrowseTableViewController: UITableViewController {
    
    
    var phoneNumber: String?
    
    var wingmen: [[String:AnyObject]] = []
    
    
    var arrayOfRegisterInfo = [[String: AnyObject]]()
    
     var arrayOfPostData = [[String: AnyObject]]()
    
       var tabBarImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
   
        
        tabBarImageView = UIImageView(frame: CGRect(x: -80, y: 0, width: 300, height: 40))
        
        
        tabBarImageView!.clipsToBounds = true
        
        tabBarImageView!.contentMode = .ScaleAspectFill
        
        tabBarImageView!.hidden = true
        
        let image = UIImage(named: "bar")
        tabBarImageView!.image = image
        navigationItem.titleView = tabBarImageView
        
        
      //  tableView.separatorColor = UIColor.blueColor()
        
        tableView.layoutMargins = UIEdgeInsetsZero
        
        tableView.separatorInset = UIEdgeInsetsZero

        let gradientView = GradientView(frame: CGRectMake(view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width, view.bounds.size.height))
        
        // Set the gradient colors
        
    
        
        

        gradientView.colors = [UIColor.blackColor(), UIColor.darkGrayColor()]
        
        // Optionally set some locations
     //   gradientView.locations = [0.0, 1.0]
        
        // Optionally change the direction. The default is vertical.
        gradientView.direction = .Vertical
        
        

//        
//        gradientView.topBorderColor = UIColor.blueColor()
//        gradientView.bottomBorderColor = UIColor.blueColor()
//
//        
   
        tableView.backgroundView = gradientView
    
             self.loadCurrentUserAndThenLoadUsers()
        
// self.tableView.hidden = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
   
    }
    
    
    override func viewWillAppear(animated: Bool) {
 
        tabBarImageView!.hidden = true
      //  self.tableView.hidden = true
        
        self.tableView.backgroundColor = UIColor.blackColor()
        
        //sets navigation bar to a clear black color
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        //sets navigation bar's "Back" button item to white
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        var backButton = UIBarButtonItem()
        var backButtonImage = UIImage(named: "backbutton")
        backButton.setBackButtonBackgroundImage(backButtonImage, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        
        self.navigationController?.navigationItem.backBarButtonItem = backButton
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
       //  self.tableView.hidden = false
        self.tableView.backgroundColor = UIColor.blackColor()
        
        
        //sets navigation bar to a clear black color
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        //sets navigation bar's "Back" button item to white
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        var backButton = UIBarButtonItem()
        var backButtonImage = UIImage(named: "backbutton")
        backButton.setBackButtonBackgroundImage(backButtonImage, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
     
        self.navigationController?.navigationItem.backBarButtonItem = backButton
        
        tabBarImageView!.hidden = false
        springScaleFrom(tabBarImageView!, 0, -100, 0.5, 0.5)
        
            // addBlurEffect()
        
        self.tableView.reloadData()
        
    }
    
    func addBlurEffect() {
        // Add blur view
        var bounds = self.navigationController?.navigationBar.bounds as CGRect!
        var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        visualEffectView.frame = bounds
        visualEffectView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        self.navigationController?.navigationBar.addSubview(visualEffectView)    // Here you can add visual effects to any UIView control.
        // Replace custom view with navigation bar in above code to add effects to custom view.
    }
    
    func loadCurrentUserAndThenLoadUsers() {
        var query = PFUser.query()
        query.whereKey("objectId", equalTo: PFUser.currentUser().objectId)
        
        query.findObjectsInBackgroundWithBlock() {
            (objects:[AnyObject]!, error:NSError!)->Void in
            if ((error) == nil) {
                
                if let user = objects.last as! PFUser? {
                    
                    
                    
                // if we created a postData, the user has a wingmanGender in parse that user is seeking
                    if let seekingGender = user["wingmanGender"] as! String? {
                        
                        if let gender = user["gender"] as! String? {
                            self.loadUsers(seekingGender, ourGender: gender)
                        }
                       
                    }
                    
                        
                        // otherwise (if we dont have a postData dict), load all users (no arguments in the function)
                    
                    else {
                        
                        self.loadUsers(nil, ourGender: nil)
                        
                    }
                }
            }
            
            
        }
        
    }
    
    func loadUsers(seekingGender: String?, ourGender: String?) {
        
//        var query = PFQuery(className:"_User")
         var query = PFUser.query()
        
         query.whereKeyExists("postData")
    
         query.whereKey("objectId", notEqualTo: PFUser.currentUser().objectId)
        
        // if we have a seekingGender, then load only users whose gender is our seekingGender, else return all users that are not current user (never go into that loop)
        if let seekingGender = seekingGender as String? {
           
            if let ourGender = ourGender as String? {
                query.whereKey("gender", equalTo: seekingGender)
                
                query.whereKey("wingmanGender", equalTo: ourGender)

            }
           
        }

        
        query.findObjectsInBackgroundWithBlock() {
            (objects:[AnyObject]!, error:NSError!)->Void in
            if ((error) == nil) {

            
                for user in objects {
                    
                    if let registerInfo = user["registerInfo"] as? [String: AnyObject] {
                        
                        self.arrayOfRegisterInfo.append(registerInfo)
                        
                    }
                    
                    if let postData = user["postData"] as? [String: AnyObject] {
                        self.arrayOfPostData.append(postData)
                        
                    
                    }
                }
                
                
            }
            self.tableView.reloadData()
        }
        
    }
 
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.arrayOfRegisterInfo.count
    }

    
 
    
    override func tableView(tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.separatorInset = UIEdgeInsetsZero
         cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
       
    }
  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! BrowseTableViewCell

        cell.selectionStyle = .None
        
        cell.contentView.backgroundColor = UIColor.clearColor()
        cell.backgroundColor = UIColor.clearColor()

        
//        
//        springScaleFrom(cell.genderLabel, 200, 200, 0.5, 0.5)
//        
//        springScaleFrom(cell.usernameLabel, 200, 200, 0.5, 0.5)
//        springScaleFrom(cell.clubOrBarLabel, 200, 200, 0.5, 0.5)
//        springScaleFrom(cell.timeLabel, 200, 200, 0.5, 0.5)
//        
//        springScaleFrom(cell.userImage, -100, 200, 0.5, 0.5)
        
        var registerInfo = self.arrayOfRegisterInfo[indexPath.row]
        
        
        if let imageFile = registerInfo["imageFile"] as? PFFile {
            imageFile.getDataInBackgroundWithBlock({
                (imageData: NSData!, error: NSError!) in
                if (error == nil) {
                    let image : UIImage = UIImage(data:imageData)!
                    //image object implementation
                    
                    cell.userImage.image = image
                }
            })

        }
        
        
//        if let interest = registerInfo["interests"] as? String {
//            cell.interestsLabel.text = interest
//        }
        
        if let username = registerInfo["username"] as? String {
            cell.usernameLabel.text = username
        }
        if let gender = registerInfo["gender"] as? String {
            
            cell.genderLabel.text = "Gender: \(gender)"
            
        }
        
        
        var postData = self.arrayOfPostData[indexPath.row]
        
        if let clubOrBar = postData["clubOrBar"] as? String {
            
            cell.clubOrBarLabel.text = clubOrBar
            
            
        }
        
//        if let seeking = postData["wingmanGender"] as? String {
//            
//            cell.seekingLabel.text = "Seeking: \(seeking)"
//            
//        }
    
        
        if let startTimeInt = postData["startTime"] as? Int {
            
            
            if let endTimeInt = postData["endTime"] as? Int {
                
                
                cell.timeLabel.text = "From: \(startTimeInt) To: \(endTimeInt)"
            }
            
            
        }
        
      
        return cell
        
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//       let cell: BrowseTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as BrowseTableViewCell

     //didn't connect segue in storyboard so doing it programmatically here
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewControllerWithIdentifier("browseDetailVC") as! BrowseDetailViewController
        
        //self for global variables/properties
        var registerInfo = self.arrayOfRegisterInfo[indexPath.row]
        var postData = self.arrayOfPostData[indexPath.row]
        
        //sending data to BrowseDetailViewController
        vc.registerInfo = registerInfo
        vc.postData = postData
        
        if let phoneNumber = postData["phonenumber"] as! String? {
            
            
            
//            self.phoneNumber = phoneNumber
            vc.phoneNumber = phoneNumber
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
       
        
        
    }

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "phoneSegue" {
//            
//            
//            
//            let vc = segue.destinationViewController as TextMessageViewController
//            
//            println(phoneNumber)
//            vc.phoneNumber = self.phoneNumber
//            
//        }
//    
//    }
    
    
   
   }
