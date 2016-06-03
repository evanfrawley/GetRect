
//
//  DB.swift
//  GetRect
//
//  Created by Nick Nordale on 6/1/16.
//  Copyright © 2016 iGuest. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import CoreLocation

class DB {
    
    var ref: FIRDatabaseReference!
    var feedRad: Int
    var feedLocation: CLLocationCoordinate2D
    var currentLocation: CLLocation!
    var refreshFeed: Bool!

    init() {
        self.ref = FIRDatabase.database().reference()
        self.feedRad = 5500
        self.feedLocation = CLLocationCoordinate2D()
        self.refreshFeed = false
    }
    
    static let sharedInstance = DB()
    
    func newUser(spotifyID: String) {
        let buildEmail = spotifyID + "@email.com"
        FIRAuth.auth()?.createUserWithEmail(buildEmail, password: spotifyID) { (user, error) in
            if error != nil {
                print("new user error")
            } else {
                print("new user success")
            }
        }
    }
    
    func login(spotifyID: String) {
        let buildEmail = spotifyID + "@email.com"
        FIRAuth.auth()?.signInWithEmail(buildEmail, password: spotifyID) { (user, error) in
            if error != nil {
                print("login error")
            } else {
                print("login success")
            }
        }
    }
    
    func newPost(songURI: String, loc: CLLocation) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            self.newPostHelper(userID!, songURI: songURI, lat: "\(loc.coordinate.latitude)",
                long: "\(loc.coordinate.longitude)", time: "\(loc.timestamp.timeIntervalSince1970)", score: 0)
        }) { (error) in
            print("new post error")
        }
    }
    
    private func newPostHelper(userID: String, songURI: String, lat: String, long: String, time: String, score: Int) {
        // Create new post at /user-posts/$userid/$postid and at
        // /posts/$postid simultaneously
        let key = ref.child("posts").childByAutoId().key
        let post = [
            "uid": userID,
            "uri": songURI,
            "location": [
                "lat": lat,
                "long": long
            ],
            "time": time,
            "score": score
        ]
        
        let childUpdates = ["/posts/\(key)": post]
        
        ref.updateChildValues(childUpdates)
    }
    
    func upvote(postID: String) {
        ref.child("posts").child(postID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let score = snapshot.value!["score"] as! Int
            self.voteHelper(postID, oldScore: score, isUpvote: true)
        }) { (error) in
            print("upvote error")
        }
    }
    
    func downvote(postID: String) {
        ref.child("posts").child(postID).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let score = snapshot.value!["score"] as! Int
            self.voteHelper(postID, oldScore: score, isUpvote: false)
        }) { (error) in
            print("upvote error")
        }
    }
    
    private func voteHelper(postID: String, oldScore: Int, isUpvote: Bool) {
        if isUpvote {
            self.ref.child("posts/\(postID)/score").setValue(oldScore + 1)
        } else {
            self.ref.child("posts/\(postID)/score").setValue(oldScore - 1)
        }
    }
    
    func getUserPosts(completionHandler: (posts: [[String: String]]) -> ()) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("posts").queryOrderedByChild("uid").queryEqualToValue(userID).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            var posts = [[String: String]]()
            
            for post in snapshot.children {
                let postID = post.ref.key
                let lat = post.value.objectForKey("location")!.objectForKey("lat")
                let long = post.value.objectForKey("location")!.objectForKey("long")
                let time = post.value!["time"] as! String
                let songURI = post.value!["uri"] as! String
                let score = post.value!["score"] as! Int
                let uid = post.value!["uid"] as! String
                
                let postRet: [String: String] = [
                    "postID": postID,
                    "lat": "\(lat)",
                    "long": "\(long)",
                    "time": time,
                    "uri": songURI,
                    "score": "\(score)",
                    "uid": uid
                ]
                
                posts.append(postRet)
            }
            
            completionHandler(posts: posts)
            
        }) { (error) in
            print("get user posts error")
        }
    }
    

    func updateFromMap(rad:Int, loc:CLLocationCoordinate2D) {
        self.feedRad = rad //meters
        self.currentLocation = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
    }
    
    func getUserScore(callback: (totalScore: Int) -> ()) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("posts").queryOrderedByChild("uid").queryEqualToValue(userID).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            var total = 0
            
            for post in snapshot.children {
                total += post.value!["score"] as! Int
            }
            
            callback(totalScore: total)
            
        }) { (error) in
            print("get user posts error")
        }
    }
    
    func getFeed(location: CLLocation, radius: Int, completionHandler: (posts: [[String: String]]) -> ()) {
        
        ref.child("posts").queryOrderedByChild("score").observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            var validPosts = [[String: String]]()
            
            for post in snapshot.children {
                let lat = Double(post.value.objectForKey("location")!.objectForKey("lat") as! String)
                let long = Double(post.value.objectForKey("location")!.objectForKey("long") as! String)
                
                let newLoc = CLLocation(latitude: lat!, longitude: long!)
                
                if location.distanceFromLocation(newLoc) < (Double(radius)) {
                    let postID = post.ref.key
                    let lat = post.value.objectForKey("location")!.objectForKey("lat")
                    let long = post.value.objectForKey("location")!.objectForKey("long")
                    let time = post.value!["time"] as! String
                    let songURI = post.value!["uri"] as! String
                    let score = post.value!["score"] as! Int
                    let uid = post.value!["uid"] as! String
                    
                    let validPost: [String: String] = [
                        "postID": postID,
                        "lat": "\(lat)",
                        "long": "\(long)",
                        "time": time,
                        "uri": songURI,
                        "score": "\(score)",
                        "uid": uid
                    ]
                    
                    validPosts.append(validPost)
                }
            }
            
            validPosts = validPosts.reverse()
            completionHandler(posts: validPosts)
            
        }) { (error) in
            print("get user posts error")
        }
    }
}



