//
//  BrowseTableViewController.swift
//  Wingman
//
//  Created by Ebony Nyenya on 3/3/15.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit



class BrowseTableViewController: UITableViewController, didGetEventsProtocol {
    
    
    var phoneNumber: String?
    
    var wingmen: [[String:AnyObject]] = []
    
    
    var arrayOfRegisterInfo = [[String: AnyObject]]()
    
     var arrayOfPostData = [[String: AnyObject]]()
    
    var arrayOfEvents = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    // self.loadCurrentUserAndThenLoadUsers()
        println("THIS IS THE TOKEN: \(User.currentUser().token)")
        
        User.currentUser().getEventsDelegate  = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        User.currentUser().getEvents()

    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        self.tableView.backgroundColor = UIColor.blackColor()
        
        //sets navigation bar to a clear black color
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        //sets navigation bar's "Back" button item to white
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        

        
    }
    
    
    func loadCurrentUserAndThenLoadUsers() {
        var query = PFUser.query()
        query.whereKey("objectId", equalTo: PFUser.currentUser().objectId)
        
        query.findObjectsInBackgroundWithBlock() {
            (objects:[AnyObject]!, error:NSError!)->Void in
            if ((error) == nil) {
                
                if let user = objects.last as PFUser? {
                    
                    
                    
                // if we created a postData, the user has a wingmanGender in parse that user is seeking
                    if let seekingGender = user["wingmanGender"] as String? {
                        
                        if let gender = user["gender"] as String? {
                            User.currentUser().getEvents()
                            //self.loadUsers(seekingGender, ourGender: gender)
                        }
                       
                    }
                    
                        
                        // otherwise (if we dont have a postData dict), load all users (no arguments in the function)
                    
                    else {
                        User.currentUser().getEvents()
                        //self.loadUsers(nil, ourGender: nil)
                        
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
        return self.arrayOfEvents.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as BrowseTableViewCell


        var event = self.arrayOfEvents[indexPath.row]
        
        
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
        
        if let username = event["creator_name"] as? String {
            cell.usernameLabel.text = username
        }
        if let gender = event["creator_gender"] as? String {
            
            cell.genderLabel.text = "Gender: \(gender)"
            
        }
        
    
        
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
        
        
        return cell
        
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
    
    
    @IBAction func Logout(sender: AnyObject) {
        
        User.currentUser().token = nil
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nc = storyboard.instantiateViewControllerWithIdentifier("loginNC") as UINavigationController
        

        //presents LoginViewController without tabbar at bottom
        self.presentViewController(nc, animated: true, completion: nil)
    }
    

   }



/*


*/
