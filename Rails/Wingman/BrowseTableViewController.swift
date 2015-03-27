//
//  BrowseTableViewController.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/3/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit

class BrowseTableViewController: UITableViewController,  didGetEventsProtocol {
    
    
    var phoneNumber: String?
    
    var wingmen: [[String:AnyObject]] = []
    
    
    var arrayOfRegisterInfo = [[String: AnyObject]]()
    
     var arrayOfPostData = [[String: AnyObject]]()
    
       var tabBarImageView: UIImageView?
    
     var arrayOfEvents = [[String: AnyObject]]()
    
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
    
        User.currentUser().getEventsDelegate  = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        User.currentUser().getEvents()
        
        
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
        return self.arrayOfEvents.count
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
        
       
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as BrowseTableViewCell

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
        
        var event = self.arrayOfEvents[indexPath.row]
        
        
        if let venue = event["venue"] as? String {
            
            cell.clubOrBarLabel.text = venue
            
            
        }
        
        //        if let seeking = postData["wingmanGender"] as? String {
        //
        //            cell.seekingLabel.text = "Seeking: \(seeking)"
        //
        //        }
        
        
        if let startTimeInt = event["start_time_string"] as? String {
            
            
            if let endTimeInt = event["end_time_string"] as? String {
                
                
                cell.timeLabel.text = "From: \(startTimeInt) To: \(endTimeInt)"
            }
            
            
        }

    

    
    
        if let userInfo = event["user"] as [String: AnyObject]? {
            
            if let username = userInfo["username"] as? String {
                cell.usernameLabel.text = username
            }
            if let gender = userInfo["gender"] as? String {
                
                cell.genderLabel.text = "Gender: \(gender)"
                
            }
            
            
            if let urlString = userInfo["image_string"] as? String {
                
                println(urlString)
                let url = NSURL(string: urlString)
                
                println(url)
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                
               //cell.userImage.image =  UIImage(data: data!)
                
               
            }
        }
        
        
                       //        if let seeking = postData["wingmanGender"] as? String {
            //
            //            cell.seekingLabel.text = "Seeking: \(seeking)"
            //
            //        }
            
        
        
            return cell

            
    
        /*
        if let imageFile = registerInfo["imageFile"] as? PFFile {
        imageFile.getDataInBackgroundWithBlock({
        (imageData: NSData!, error: NSError!) in
        if (error == nil) {x
        let image : UIImage = UIImage(data:imageData)!
        //image object implementation
        
        cell.userImage.image = image
        }
        })
        
        }
        */
        
        //        if let interest = registerInfo["interests"] as? String {
        //            cell.interestsLabel.text = interest
        //        }
        
        
        
    }
    
    func didGetAllEvents(events: [[String: AnyObject]]) {
        

        for event in events {
            self.arrayOfEvents.append(event)
        }
        
        self.tableView.reloadData()
        
    }
    
    func didNotGetAllEvents(error: String?) {
        var alert:UIAlertView = UIAlertView(title: "Get Events Unsuccessful", message: error, delegate: nil, cancelButtonTitle: "Ok")
        
        alert.show()
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //       let cell: BrowseTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as BrowseTableViewCell
        
        //didn't connect segue in storyboard so doing it programmatically here
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        let vc = storyboard.instantiateViewControllerWithIdentifier("browseDetailVC") as BrowseDetailViewController
        
        //self for global variables/properties
        
        //sending data to BrowseDetailViewController
        
        /*
        vc.registerInfo = registerInfo
        vc.postData = postData
        */
        
        var event = self.arrayOfEvents[indexPath.row]
        
        vc.event = event
        if let phoneNumber = event["creator_phone_number"] as? String {
            
            
            
            //            self.phoneNumber = phoneNumber
            vc.phoneNumber = phoneNumber
            
            
        }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        

        
        
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
