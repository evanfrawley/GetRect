//
//  SpotifyAPIHandler.swift
//  GetRect
//
//  Created by Evan on 5/26/16.
//  Copyright © 2016 iGuest. All rights reserved.
//

import SwiftyJSON
import Alamofire

class SpotifyAPIHandler {
    
    var player:SPTAudioStreamingController?
    var feedURIs:NSArray
    var postURIs:NSArray
    let kClientID = "1a475789c4004e6584ad764a80430f52"
    
    init() {
        self.player = SPTAudioStreamingController(clientId: kClientID)
        self.feedURIs = []
        self.postURIs = []
    }
    
    func callSearch(params:String, completionHandler: (responseObject:JSON)->() ) {
        let newParams:String = params.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let dict = ["q":newParams, "type":"track"]
        makeCall("search", params: dict, completionHandler: completionHandler)
    }
    
    func callTracks( params:String, completionHandler: (responseObject:JSON)->() ) {
        let dict = ["ids":params]
        makeCall("tracks", params: dict, completionHandler: completionHandler)
    }
    
    func parseSpotifyID(fbData:JSON) -> String {
        var combinedURI:String = ""
        
        for (_,subJson):(String, JSON) in fbData {
            let trackURI:String = subJson["uri"].stringValue.componentsSeparatedByString(":")[2]
            if combinedURI == "" {
                combinedURI = trackURI
            } else {
                combinedURI += (",\(trackURI)")
            }
        }
        return combinedURI
    }
    
    //takes all of the URI and then calls the spotify API to get hte JSON response data

    //calls the spotify API and returns the response data in a reponse object of type JSON
    func makeCall(searchType:String, params:NSDictionary, completionHandler: (responseObject: JSON) -> ()) {
        let baseURL = "https://api.spotify.com/v1/"
        let callURL = "\(baseURL)\(searchType)"
        print(callURL)
        
        Alamofire.request(.GET, callURL, parameters: params as? [String : AnyObject])
            .responseJSON { response in
                completionHandler(responseObject: JSON(response.result.value!))
        }
    }
    
    func startStreamingSession(sessionObj:SPTSession!, index:Int32, type:String) {
        
        if self.player == nil {
            self.player = SPTAudioStreamingController(clientId: kClientID)
        }
        
        //check if nil
        var playingURIs:NSArray = []
        if type == "Feed" {
            playingURIs = feedURIs
        //should be else if type == "Post"
        } else {
            playingURIs = postURIs
        }
        
        if !self.player!.loggedIn {
            //this should be where i set the player to do something kek
            self.player?.loginWithSession(sessionObj, callback: { (error:NSError!) in
                print("i'm in the login")
                if error != nil {
                    print("got this error for playback: \(error)")
                    return
                }
            })
        }
        
        self.player?.playURIs(playingURIs as [AnyObject], fromIndex: index, callback: { (error:NSError!) in
            print("i'm in the player")
            if error != nil {
                print("error while starting playback: \(error)")
                return
            } else {
                print("should be playing")
            }
        })
        
        //play at particular index
    }
    //TODO: get tracks, get search modualarize

    //add in pull down to refresh, implement "Hot" and "New" tabs
    
    func injectFeedURIs(uris:NSArray) {
        self.feedURIs = uris
    }
    func injectPostURIs(uris:NSArray) {
        self.postURIs = uris
    }
    
    func prev() {
        self.player?.skipPrevious(nil)
    }
    
    func next() {
        self.player?.skipNext(nil)
    }
    
    func pausePlay() {
        self.player!.setIsPlaying(!self.player!.isPlaying, callback: nil)
    }
    
    
    //replaceURIswithcurrent track
    
}
