//
//  ViewController.swift
//  GetRect
//
//  Created by iGuest on 5/12/16.
//  Copyright © 2016 iGuest. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
import MapKit


class ViewController: UIViewController, CLLocationManagerDelegate {

    let kClientID = "1a475789c4004e6584ad764a80430f52"
    let kCallbackURL = "getrect://callback"
    let kClientSecret = "114ba2547a2c47d39abe3bdc6dd662d6"
    
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var button: UIButton!
    var session:SPTSession!
    var player:SPTAudioStreamingController?
    let auth = SPTAuth.defaultInstance()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DB.sharedInstance.login("123456789")
        
        // Can use this to grey out the app until location services are allowed
        //   then set to clearColor.
        //view.backgroundColor = UIColor.grayColor()
        //view.backgroundColor = UIColor.clearColor()
        
        locationManager = CLLocationManager()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        DB.sharedInstance.getUserPosts()
        
        // LOGIN: DB.sharedInstance.login("123456789") [spotify user id]
        // SIGNUP: DB.sharedInstance.newUser("123456789") [spotify user id]
        
        // UPVOTE: DB.sharedInstance.upvote("-KJCgzvjSDsbcujWBgZW") [post id]
        // DOWNVOTE: DB.sharedInstance.downvote("-KJCgzvjSDsbcujWBgZW") [post id]
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // NEW POST: DB.sharedInstance.newPost("Redemption", loc: locations.last!) [song name and location]
        print("location: [\(locations.last!.coordinate.latitude), \(locations.last!.coordinate.longitude)]")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.code)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .Authorized:
            print("authorized")
        case .AuthorizedWhenInUse:
            print("authorized when in use")
        case .Denied:
            print("denied")
        case .NotDetermined:
            print("not determined")
        case .Restricted:
            print("restricted")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.auth.clientID = kClientID
        self.auth.redirectURL = NSURL(string: kCallbackURL)
        self.auth.sessionUserDefaultsKey = "SpotifySession"
        self.auth.requestedScopes = [SPTAuthStreamingScope]
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.updateAfterLogin), name: "successfulLogin", object: nil)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let sessionObj:AnyObject = userDefaults.objectForKey("SpotifySession") {
            let sessionDataObj = sessionObj as! NSData
            let session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as! SPTSession
            if !session.isValid() {
                UIApplication.sharedApplication().openURL(self.auth.loginURL)
            } else {
                self.button.hidden = true
                self.updateAfterLogin()
            }
        } else {
            self.button.hidden = false
        }
    }
    
    @IBAction func login(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(self.auth.loginURL)
        //self.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateAfterLogin() {
        print("should go to tab controller")
        let tbc :AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("TabController")
        self.showViewController(tbc as! UITabBarController, sender: self)
    }

    
    func playUsingSession(sessionObj:SPTSession!){
        
        print("entered session player")
        if self.player == nil {
            self.player = SPTAudioStreamingController(clientId: kClientID)
            print("player init")
        }
        
        print("token is: \(sessionObj.accessToken)")
        self.player?.loginWithSession(sessionObj, callback: { (error:NSError!) in
            if error != nil {
                print("got this error for playback: \(error)")
                return
            }
            
            let array:NSArray = [NSURL(string: "spotify:track:2GQEM9JuHu30sGFvRYeCxz")!, NSURL(string: "spotify:track:5v8umLXzP5j4BDqDxqEyTp")!, NSURL(string: "spotify:track:1NB0VPwAw6Rx8b9qvDKB5M")!]
            
            self.player?.playURIs(array as [AnyObject], fromIndex: 0, callback: { (error:NSError!) in
                if error != nil {
                    print("error while starting playback: \(error)")
                    return
                } else {
                    print("should be playing")
                }
            })
        })
    }
}


