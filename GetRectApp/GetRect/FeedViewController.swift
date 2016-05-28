//
//  FeedViewController.swift
//  GetRect
//
//  Created by Evan on 5/20/16.
//  Copyright © 2016 iGuest. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //things that I need to get from the spotify API
    /* URI
     * track name
     * artist name
     * img url
     */
    /*
     example of a test call with Alamofire / SwiftJSON
     let baseURL = "https://api.spotify.com/v1/tracks"
     let params = ["ids": "0eGsygTp906u18L0Oimnem,37S0dTkF8GlXoZi7j4Sbzr"]
     
     let test = Alamofire.request(.GET, baseURL, parameters: params)
     .responseJSON{ response in
     
     NSLog("this should do something")
     let json = JSON(response.result.value!)
     let testString = json["tracks", 0, "uri"].stringValue
     NSLog(testString)
     
     }
 
     */
    
    //placeholder for the inteded firebase JSON data
    var placeholder :JSON = [
            ["uri": "spotify:track:4Y8XcGssM81dwtlbjkqfm5",
            "user": "evanfrawley",
            "timestamp": "123/123/123",
            "score": 666,
            "geoloc": [47.6062,122.3321],
            "fbid": "123123123123"],
            
            ["uri": "spotify:track:2G5nzWdblGm29nO1r7WxCU",
            "user": "evanfrawley",
            "timestamp": "123/123/123",
            "score": 420,
            "geoloc": [47.6062,122.3321],
            "fbid": "123123123123"],
            
            ["uri": "spotify:track:0Ix7doBgImhoWJfDnwezP1",
            "user": "evanfrawley",
            "timestamp": "123/123/123",
            "score": 123,
            "geoloc": [47.6062,122.3321],
                "fbid": "123123123123"],

            
            ["uri": "spotify:track:3UgSQu6WwrXfKKDq019IHE",
                "user": "evanfrawley",
                "timestamp": "123/123/123",
                "score": 123,
                "geoloc": [47.6062,122.3321],
                "fbid": "123123123123"],
            
            ["uri": "spotify:track:48bSfSZaq9Aizbu4AWn4st",
                "user": "evanfrawley",
                "timestamp": "123/123/123",
                "score": 123,
                "geoloc": [47.6062,122.3321],
                "fbid": "123123123123"],
            
            ["uri": "spotify:track:0P6RjFd2HgG2AXJadQuGfE",
                "user": "evanfrawley",
                "timestamp": "123/123/123",
                "score": 123,
                "geoloc": [47.6062,122.3321],
                "fbid": "123123123123"],
            
            ["uri": "spotify:track:66hayvUbTotekKU3H4ta1f",
                "user": "evanfrawley",
                "timestamp": "123/123/123",
                "score": 123,
                "geoloc": [47.6062,122.3321],
                "fbid": "123123123123"]
            ]
    
    let api:SpotifyAPIHandler = SpotifyAPIHandler.init()
    
    var data:JSON = JSON([:])


    //use this formatting: http://stackoverflow.com/questions/26672547/swift-handling-json-with-alamofire-swiftyjson
    @IBOutlet weak var tableView: UITableView!
    
    //initializer viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //makes call to start getting the spotify API data
        api.callTracks(api.parseSpotifyID(self.placeholder)) { (responseObject) in
            self.data = responseObject
            self.tableView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //initializes the tableview cells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath) as! FeedTableCell
        let post = self.data["tracks", indexPath.row]
        
        
        cell.title?.text = post["name"].stringValue
        cell.artist?.text = post["artists", 0, "name"].stringValue
        cell.uri = post["uri"].stringValue
        if post["album", "images", 0, "url"].stringValue != "" {
            let imgURL:NSURL = NSURL(string: post["album", "images", 0, "url"].stringValue)!
            let imgData:NSData? = NSData(contentsOfURL: imgURL)
            cell.art?.image = UIImage(data: imgData!)
        }
        return cell
        
    }
    
    //required function
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeholder.count
    }
    
    //required function
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
}
    



