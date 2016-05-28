//
//  ViewController.swift
//  GetRect
//
//  Created by iGuest on 5/12/16.
//  Copyright © 2016 iGuest. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    let kClientID = "1a475789c4004e6584ad764a80430f52"
    let kCallbackURL = "getrect://callback"

    
    
    @IBOutlet weak var button: UIButton!
    var session:SPTSession!
    var player:SPTAudioStreamingController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.updateAfterLogin), name: "successfulLogin", object: nil)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let sessionObj:AnyObject = userDefaults.objectForKey("SpotifySession") {
            //do something
            let sessionDataObj = sessionObj as! NSData
            let session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionDataObj) as! SPTSession
            
            if !session.isValid() {
                SPTAuth.defaultInstance().renewSession(session, callback: { (error:NSError!, session:SPTSession!) in
                    if error == nil {
                        let sessionData = NSKeyedArchiver.archivedDataWithRootObject(session)
                        userDefaults.setObject(sessionData, forKey: "SpotifySession")
                        userDefaults.synchronize()
                        
                        self.session = session
                        self.playUsingSession(session)
                    } else {
                        print("error refreshing session")
                    }
                })
            } else {
                print("session valid")
                self.playUsingSession(session)
            }
            
        } else {
            self.button.hidden = false
        }
        
    }
    
    @IBAction func login(sender: AnyObject) {
        NSLog("button clicked")
        
        let auth = SPTAuth.defaultInstance()
        auth.clientID = kClientID
        auth.redirectURL = NSURL(string: kCallbackURL)
        auth.requestedScopes = [SPTAuthStreamingScope]
        
        let loginurl = auth.loginURL
        
        UIApplication.sharedApplication().openURL(loginurl)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateAfterLogin() {
        self.button.hidden = true
    }
    
    func playUsingSession(sessionObj:SPTSession!){
        
        print("entered session player")
        if self.player == nil {
            self.player = SPTAudioStreamingController(clientId: kClientID)
            print("player init")
        }
        print("1")
        print("token is: \(sessionObj.accessToken)")
        self.player?.loginWithSession(sessionObj, callback: { (error:NSError!) in
            print("2")
            if error != nil {
                print("3")
                print("got this error for playback: \(error)")
                return
            }
            print("4")
            let trackURI = NSURL(string: "spotify:track:5BRrBkpj0An7PViNqMCoGa")
            
            self.player?.playURI(trackURI, callback: { (error:NSError!) in
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


