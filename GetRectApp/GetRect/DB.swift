
//
//  DB.swift
//  GetRect
//
//  Created by Nick Nordale on 6/1/16.
//  Copyright © 2016 iGuest. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class DB {
    
    struct Post {
        let song: String
        let score: Int
        let uid: String
        let location: [String]
    }
    
    var ref: FIRDatabaseReference!

    init() {
        self.ref = FIRDatabase.database().reference()
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
    
    func newPost(song: String, loc: CLLocation) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            self.newPostHelper(userID!, song: song, lat: "\(loc.coordinate.latitude)",
                long: "\(loc.coordinate.longitude)", score: 0)
        }) { (error) in
            print("new post error")
        }
    }
    
    private func newPostHelper(userID: String, song: String, lat: String, long: String, score: Int) {
        // Create new post at /user-posts/$userid/$postid and at
        // /posts/$postid simultaneously
        let key = ref.child("posts").childByAutoId().key
        let post = [
            "uid": userID,
            "song": song,
            "location": [
                "lat": lat,
                "long": long
            ],
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
    
    func getUserPosts() {
        let userID = FIRAuth.auth()?.currentUser?.uid
        print("user id: \(userID)")
        ref.child("posts").queryOrderedByChild("uid").queryEqualToValue(userID).observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            //var posts = [[String: String]]()
            
            for post in snapshot.children {
                print(post.value.objectForKey("location"))
                /*let lat = post.value!["location"].child("lat")
                let long = post.value!["location"]!!.value!["lat"]
                let song = post.value!["song"] as! String
                let score = post.value!["score"] as! Int
                let uid = post.value!["uid"] as! String
                
                var post: [String: String] = [
                    "lat": "\(lat)",
                    "long": "\(long)",
                    "song": song,
                    "score": "\(score)",
                    "uid": uid
                ]
                
                posts.append(post)*/
            }
            
            //self.getUserPostsHelper(posts)
            
        }) { (error) in
            print("get user posts error")
        }
    }
    
    private func getUserPostsHelper(postArray: [[String: String]]) {
        for post in postArray {
            print("song=\(post["song"]), score=\(post["score"]), location=[\("lat"), \("long")], uid=\("uid")")
        }
    }
}

















