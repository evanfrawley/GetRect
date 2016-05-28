//
//  PostViewController.swift
//  GetRect
//
//  Created by Evan on 5/20/16.
//  Copyright © 2016 iGuest. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    
    
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

            ]
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var api = SpotifyAPIHandler.init()
    var data:JSON = JSON([:])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
        // Do any additional setup after loading the view.
        self.searchBar.showsCancelButton = true
        //self.searchBar.delegate = self.delegate
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //initializes the tableview cells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostTableCell
        
        print(indexPath.row)
        
        let post = self.data["tracks", "items", indexPath.row]
        
        
        cell.title?.text = post["name"].stringValue
        cell.artist?.text = post["artists", 0, "name"].stringValue
        cell.uri = post["uri"].stringValue
        print(cell.uri)
        if post["album", "images", 0, "url"].stringValue != "" {
            let imgURL:NSURL = NSURL(string: post["album", "images", 0, "url"].stringValue)!
            let imgData:NSData? = NSData(contentsOfURL: imgURL)
            cell.art?.image = UIImage(data: imgData!)
        }
        
        
        return cell
    }
    
    
    
    //required function
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(data["tracks", "items"].count)
        return data["tracks", "items"].count
    }
    
    //required function
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        self.searchBar.resignFirstResponder()
        self.searchBar.text = ""
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.searchBar.resignFirstResponder()
        let searchQuery = self.searchBar.text!
        print(searchQuery)
        api.callSearch(searchQuery) { (responseObject) in
            self.data = responseObject
            print(responseObject)
            self.tableView.reloadData()
        }
        
        
    }
    


}
