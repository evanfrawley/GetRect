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

class FeedViewController: UIViewController {

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
    

    //use this formatting: http://stackoverflow.com/questions/26672547/swift-handling-json-with-alamofire-swiftyjson
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let baseURL = "https://api.spotify.com/v1/tracks"
        let params = ["ids": "0eGsygTp906u18L0Oimnem,37S0dTkF8GlXoZi7j4Sbzr"]

        let test = Alamofire.request(.GET, baseURL, parameters: params)
            .responseJSON{ response in
            
            NSLog("this should do something")
            let json = JSON(response.result.value!)
            let testString = json["tracks", 0, "uri"].stringValue
            NSLog(testString)
                
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
