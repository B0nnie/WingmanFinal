//
//  BrowseDetailViewController.swift
//  Wingman
//
//  Created by William McDuff on 2015-03-06.
//  Copyright (c) 2015 Ebony Nyenya. All rights reserved.
//

import UIKit
import MessageUI

class BrowseDetailViewController: UIViewController, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate {

    
    var registerInfo: [String: AnyObject]?
    
    var postData: [String: AnyObject]?
    
    var venueLocation: PFGeoPoint?
    
    var phoneNumber: String?
    
    
    var myCustomBackButtonItem: UIBarButtonItem?
    
    var customButton: UIButton?

    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var userImage: UIImageView!
    
    
    @IBOutlet weak var genderLabel: UILabel!
    
    
    @IBOutlet weak var interestsLabel: UILabel!
    
    
    @IBOutlet weak var seekingLabel: UILabel!
    

    
    @IBOutlet weak var clubOrBarLabel: UILabel!
    
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var joinButton: UIButton!
    
    var imageView: UIImageView?
    
    @IBAction func joinButton(sender: AnyObject) {
         messageUser()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
        joinButton.titleLabel!.adjustsFontSizeToFitWidth = true

         joinButton.titleLabel!.minimumScaleFactor = 0.3
        
        userImage.layer.cornerRadius = userImage.frame.size.width/2
        
       
        interestsLabel.layer.cornerRadius = interestsLabel.frame.size.width/20
        fillLabels()
        
        startUpdatingLocation()
        
        customButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        customButton!.setBackgroundImage(UIImage(named: "backbutton"), forState: UIControlState.Normal)
        
        
        customButton!.sizeToFit()
        
        customButton!.hidden = true
        customButton!.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
        
        myCustomBackButtonItem = UIBarButtonItem(customView: customButton!)
        
        
        
        self.navigationItem.leftBarButtonItem = myCustomBackButtonItem

        imageView = UIImageView(frame: CGRect(x: -80, y: 0, width: 300, height: 40))
        
        
        imageView!.clipsToBounds = true
        
        imageView!.contentMode = .ScaleAspectFill
        
        imageView!.hidden = true
        let image = UIImage(named: "bar")
        imageView!.image = image
        navigationItem.titleView = imageView
        
        // Do any additional setup after loading the view.
        
        self.userImage.hidden = true
        self.joinButton.hidden = true
        
        
    }
    
    override func viewDidAppear(animated:Bool){
        
      //  self.navigationController?.navigationItem.backBarButtonItem =
        
         println(self.phoneNumber)
        
        startUpdatingLocation()
        
        customButton!.hidden = false
        springScaleFrom(customButton!, -100, 0, 0.5, 0.5)

        
         imageView!.hidden = false
        springScaleFrom(imageView!, 200, 0, 0.5, 0.5)
        
         self.userImage.hidden = false
        springScaleFrom(userImage!, 0, -400, 0.5, 0.5)
        
        self.joinButton.hidden = false
        springScaleFrom(joinButton!, 0, 200, 0.5, 0.5)
        
        
    }
    
    
    func popToRoot(sender:UIBarButtonItem) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    func fillLabels() {
        
        if let registerInfo = registerInfo  {
            
            if let username = registerInfo["username"] as? String {
                
                self.usernameLabel.text = username
            }
            
            if let interests = registerInfo["interests"] as? String {
                
                self.interestsLabel.text = interests
            }
            
            if let gender = registerInfo["gender"] as? String {
                
                self.genderLabel.text = gender
            }
            
            if let imageFile = registerInfo["imageFile"] as? PFFile {
                
           //taking PPFile and turning it into data and then into UIImage
                    imageFile.getDataInBackgroundWithBlock({
                        (imageData: NSData!, error: NSError!) in
                        if (error == nil) {
                            let image : UIImage = UIImage(data:imageData)!
                            //image object implementation
                            
                            self.userImage.image = image
                        }
                    })
                    

            }
            
            
            
            
        }
        
        
        if let postData = postData {
            
            if let clubOrBar = postData["clubOrBar"] as? String {
                
                self.clubOrBarLabel.text = clubOrBar
            }
            
            if let startTime = postData["startTime"] as? Int {
                
                self.startTimeLabel.text = "From: \(startTime)"
            }
            
            if let endTime = postData["endTime"] as? Int {
                
                self.endTimeLabel.text = "To: \(endTime)"
                
                
            }
            
            if let wingmanGender = postData["wingmanGender"] as? String {
                
                self.seekingLabel.text = "Seeking \(wingmanGender) Wingman"
                
            }
            
            //retrieving location from Parse
            if let venueLocation = postData["location"] as? PFGeoPoint {
                self.venueLocation = venueLocation
            }
        }
    }
    
    //sending phone number to TextMessageViewController before going to text messaging client
  
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(manager:CLLocationManager!, didUpdateLocations locations:[AnyObject]!) {
        
        println("Springtime is here!!!")
        let location = getLatestMeasurementFromLocations(locations)
        
        
        println("my location: \(location)")
        if isLocationMeasurementNotCached(location) && isHorizontalAccuracyValidMeasurement(location) && isLocationMeasurementDesiredAccuracy(location) {
            
            stopUpdatingLocation()
           
            if let latitude =  self.venueLocation?.latitude  as Double? {
                
                if let longitude = self.venueLocation?.longitude as Double? {
                    
                    if let venueLocation = CLLocation(latitude: latitude, longitude: longitude) as CLLocation? {
                        
                        //convert meters into miles
                        var dist1 = venueLocation.distanceFromLocation(location) * 0.00062137
                        
                        //rounding to nearest hundredth
                        var dist2 = Double(round(100 * dist1) / 100)
                        
                        
                        self.distanceLabel.text = "Which is \(dist2) mi from you"
                        
                        println("THE DISTANCE: \(dist2)")
                    }
                }
                
            }
            
        }
    }
    
    //if error stop updating location
    func locationManager(manager:CLLocationManager!, didFailWithError error:NSError!) {
        if error.code != CLError.LocationUnknown.rawValue {
            stopUpdatingLocation()
        }
    }
    
    func getLatestMeasurementFromLocations(locations:[AnyObject]) -> CLLocation {
        return locations[locations.count - 1] as! CLLocation
    }
    
    func isLocationMeasurementNotCached(location:CLLocation) -> Bool {
        return location.timestamp.timeIntervalSinceNow <= 5.0
    }
    
    func isHorizontalAccuracyValidMeasurement(location:CLLocation) -> Bool {
        return location.horizontalAccuracy >= 0
    }
    
    func isLocationMeasurementDesiredAccuracy(location:CLLocation) -> Bool {
        
        return location.horizontalAccuracy <= lManager.desiredAccuracy
    }
    
    func startUpdatingLocation() {
        lManager.delegate = self
        lManager.desiredAccuracy = kCLLocationAccuracyKilometer
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            lManager.requestAlwaysAuthorization()
        }
        
        lManager.startUpdatingLocation()
        println("start updating location")
    }
    
    func stopUpdatingLocation() {
        lManager.stopUpdatingLocation()
        lManager.delegate = nil
    }
    
    func messageUser() {
        if MFMessageComposeViewController.canSendText() {
            let messageController:MFMessageComposeViewController = MFMessageComposeViewController()
            
            
            if let phoneNumber = self.phoneNumber as String? {
                
                messageController.recipients = ["\(phoneNumber)"]
                
                messageController.messageComposeDelegate = self
                
                self.presentViewController(messageController, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        
        let user = PFUser.currentUser() as PFUser
        
        PFUser.logOut()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nc = storyboard.instantiateViewControllerWithIdentifier("loginNC") as! UINavigationController
        
        
        //presents LoginViewController without tabbar at bottom
        self.presentViewController(nc, animated: true, completion: nil)
    }
    


}
