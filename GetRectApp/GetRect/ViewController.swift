//
//  ViewController.swift
//  GetRect
//
//  Created by iGuest on 5/12/16.
//  Copyright © 2016 iGuest. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    let ClientID = "1a475789c4004e6584ad764a80430f52"
    let CallBackURL = "getRect://returnAfterLogin"
    let TokenSwapURL = "http://localhost:1234/swap"
    let ToeknRefreshServiceURL = "http://localhost:1234/refresh"
    
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    @IBAction func loginWithSpotify(sender: AnyObject) {
        //let auth = SPTAuth.defaultInstance()
        
        let loginURL = SPTAuth.loginURLForClientId(ClientID, withRedirectURL: NSURL(string: CallBackURL), scopes: [SPTAuthStreamingScope], responseType: "code")
        
        UIApplication.sharedApplication().openURL(loginURL)
        NSLog("woohoo!")
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

