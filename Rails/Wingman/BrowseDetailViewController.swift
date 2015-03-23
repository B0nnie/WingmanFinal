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


    var event: [String: AnyObject]?
    var venueLocation: PFGeoPoint?
    
    var phoneNumber: String?

    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var userImage: UIImageView!
    
    
    @IBOutlet weak var genderLabel: UILabel!
    
    
    @IBOutlet weak var interestsLabel: UILabel!
    
    
    @IBOutlet weak var seekingLabel: UILabel!
    

    
    @IBOutlet weak var clubOrBarLabel: UILabel!
    
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    
    
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBAction func joinButton(sender: AnyObject) {
         messageUser()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        println(self.phoneNumber)
        fillLabels()
        
        startUpdatingLocation()
       
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated:Bool){
        
        
        startUpdatingLocation()
        
    }
    
    func fillLabels() {
        
        if let event = event  {
            
            if let username = event["creator_name"] as? String {
                
                self.usernameLabel.text = username
            }
            
            if let interests = event["creator_interests"] as? String {
                
                self.interestsLabel.text = interests
            }
            
            if let gender = event["creator_gender"] as? String {
                
                self.genderLabel.text = gender
            }
            
            
            
            if let clubOrBar = event["venue"] as? String {
                
                self.clubOrBarLabel.text = clubOrBar
            }
            
            if let startTime = event["start_time_string"] as? String {
                
                self.startTimeLabel.text = "From: \(startTime)"
            }
            
            if let endTime = event["end_time_string"] as? String {
                
                self.endTimeLabel.text = "To: \(endTime)"
                
                
            }
            
            if let wingmanGender = event["wingman_gender"] as? String {
                
                self.seekingLabel.text = "Seeking \(wingmanGender) Wingman"
                
            }
            
            //retrieving location from Parse
            if let latitudeFloat = event["latitude"] as? Float {
                
                if let longitudeFloat = event["longitude"] as? Float {
                    
                    
                    
                    var latitude = Double(latitudeFloat)
                    var longitude = Double(longitudeFloat)
                    
                    println("LATITUDE IS : \(latitude)")
                    println("LONGITUDE IS : \(longitude)")
                    var venueLocation = PFGeoPoint(latitude: latitude, longitude: longitude)
                    self.venueLocation = venueLocation
                }
                
            }

            
            /*
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
            
            
            
            */
            
        }
        

        
    }
    
    //sending phone number to TextMessageViewController before going to text messaging client
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "browseDetailToMessageVC" {
            
            /*
            let vc = segue.destinationViewController as TextMessageViewController
            
            vc.phoneNumber = self.phoneNumber
            */
        }
        
    }
    

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
        return locations[locations.count - 1] as CLLocation
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
    
    


}
