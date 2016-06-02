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
import CoreLocation

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var player:SPTAudioStreamingController?
    var playableURIs:NSArray?
    let kClientID = "1a475789c4004e6584ad764a80430f52"
    let api:SpotifyAPIHandler = SpotifyAPIHandler.init()
    var data:JSON = JSON([:])
    var postRef:PostViewController!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var playButton: UIToolbar!
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager: CLLocationManager!
    var isFirstLocationUpdate: Bool!
    
    //placeholder for the inteded firebase JSON data
    var placeholder :[[String: String]] = [[String: String]]()
    
    //initializer viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        locationManager = CLLocationManager()
        isFirstLocationUpdate = true
        DB.sharedInstance.refreshFeed = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.tableView.dataSource = self
        
        postRef = self.tabBarController?.viewControllers![1] as! PostViewController
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if isFirstLocationUpdate! {
            print("burning cached location")
            isFirstLocationUpdate = false
            return
        } else {
            //print("[\(locations.last!.coordinate.latitude), \(locations.last!.coordinate.longitude)]")
            DB.sharedInstance.currentLocation = locations.last!
            if DB.sharedInstance.refreshFeed! {
                loadFeed()
                DB.sharedInstance.refreshFeed = false
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error getting location")
    }
    
    func loadFeed() {
        print("GETTING FEED")
        DB.sharedInstance.getFeed(DB.sharedInstance.currentLocation!, radius: DB.sharedInstance.feedRad) { (posts) in
            self.placeholder = posts
            print(posts)
            
            self.api.callTracks(self.api.parseSpotifyID(self.placeholder)) { (responseObject) in
                self.data = responseObject
                self.makePlayableURIArray(responseObject)
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //initializes the tableview cells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath) as! FeedTableCell
        let post = self.data["tracks", indexPath.row]
        cell.title?.text = post["name"].stringValue
        cell.artist?.text = post["artists", 0, "name"].stringValue
        cell.uri = post["uri"].stringValue
        if post["album", "images", 0, "url"].stringValue != "" {
            let imgURL:NSURL = NSURL(string: post["album", "images", 2, "url"].stringValue)!
            let imgData:NSData? = NSData(contentsOfURL: imgURL)
            cell.art?.image = UIImage(data: imgData!)
        }
        return cell
    }
    
    func makePlayableURIArray(data:JSON) {
        var uris:NSArray = []
        
        for uri in 0 ..< data["tracks"].count {
            uris = uris.arrayByAddingObject(NSURL(string: data["tracks", uri, "uri"].stringValue)!)
        }
        print(uris)
        self.playableURIs = uris
    }
    
    //required function
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeholder.count
    }
    
    //required function
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //swipe left and right
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let like = UITableViewRowAction(style: .Normal, title: "👍") { action, index in
            print("like button tapped")
        }
        like.backgroundColor = UIColor.greenColor()
        
        let dislike = UITableViewRowAction(style: .Normal, title: "👎") { action, index in
            print("dislike button tapped")
        }
        dislike.backgroundColor = UIColor.redColor()
        
        return [like, dislike]
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row:NSInteger = indexPath.row
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let sesh = userDefaults.objectForKey("SpotifySession") as! NSData
        let session = NSKeyedUnarchiver.unarchiveObjectWithData(sesh) as! SPTSession
        
        self.playUsingSession(session, row: row)
    }
    
    func playUsingSession(sessionObj:SPTSession!, row:NSInteger){
        let newRow:Int32 = Int32(row)
        api.injectFeedURIs(self.playableURIs!)
        api.startStreamingSession(sessionObj, index: newRow, type: self.title!)
    }
    
    
    @IBAction func prevButton(sender: AnyObject) {
        api.prev()
    }
    
    @IBAction func playPauseButton(sender: AnyObject) {
        api.pausePlay()
        
    }

    
    @IBAction func next(sender: AnyObject) {
        api.next()
    }
    
}
    



