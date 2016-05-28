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
    
    //TODO: get tracks, get search modualarize

    
}
