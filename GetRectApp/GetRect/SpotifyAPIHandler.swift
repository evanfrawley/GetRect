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
    
    init() {
        
    }
    
    func callSearch( params:[String], completionHandler: (responseObject:JSON)->() ) {
        ///reset params
        
        makeCall(params, completionHandler: completionHandler)
    }
    
    func callTracks( params:[String], completionHandler: (responseObject:JSON)->() ) {
        
        //reset params
        makeCall(params, completionHandler: completionHandler)
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
    func makeCall(params:[String], completionHandler: (responseObject: JSON) -> ()) {
        let spotifyParams = ["ids":params]
        Alamofire.request(.GET, "https://api.spotify.com/v1/tracks", parameters: spotifyParams)
            .responseJSON { response in
                completionHandler(responseObject: JSON(response.result.value!))
        }
    }
    
    //TODO: get tracks, get search modualarize

    
}
