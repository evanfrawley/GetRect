//
//  ViewController.swift
//  GetRect
//
//  Created by iGuest on 5/12/16.
//  Copyright © 2016 iGuest. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase
import CoreLocation
import Mapbox


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let kClientID = "1a475789c4004e6584ad764a80430f52"
    let kCallbackURL = "getrect://callback"
    let kClientSecret = "114ba2547a2c47d39abe3bdc6dd662d6"
    
    @IBOutlet weak var button: UIButton!
    var session:SPTSession!
    var player:SPTAudioStreamingController?
    let auth = SPTAuth.defaultInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as! SPTSession
            print(session.isValid())
            if session.isValid() {
                self.button.hidden = true
                self.updateAfterLogin()
            } else {
                login("")
            }
        } else {
            self.button.hidden = false
        }
    }
    
    func firebaseAuth(session: SPTSession!) {
        let spotifyID = session.canonicalUsername
        FIRAuth.auth()?.signInWithEmail(spotifyID + "@email.com", password: spotifyID) { (user, error) in
            if let error = error {
                print("Firebase error: \(error.localizedDescription)")
                FIRAuth.auth()?.createUserWithEmail(spotifyID + "@email.com", password: spotifyID, completion: { (user, e) in
                    if let e = e {
                        print("Firebase error: \(e.localizedDescription)")
                    } else {
                        print("Firebase new account created!")
                    }
                })
                return
            } else {
                print("Firebase login worked!")
            }
        }
    }
    
    @IBAction func login(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(self.auth.loginURL)
        //viewDidAppear(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateAfterLogin() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let sessionObj:AnyObject = userDefaults.objectForKey("SpotifySession") {
            let sessionDataObj = sessionObj as! NSData
            session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as! SPTSession
            if session.isValid() {
                firebaseAuth(session)
            } else {
                login("")
            }
        }
        
        print("should go to tab controller")
        let tbc :AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("TabController")
        self.showViewController(tbc as! UITabBarController, sender: self)
    }
}


