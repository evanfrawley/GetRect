//
//  TabBarViewController.swift
//  GetRect
//
//  Created by Evan on 5/31/16.
//  Copyright © 2016 iGuest. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    var player:SPTAudioStreamingController!
    var test:String = "hi"
    
    override func viewWillAppear(animated: Bool) {
        
        let post = storyboard?.instantiateViewControllerWithIdentifier("PostScene") as! PostViewController
        post.tabBarItem.image = UIImage(named: "recommend")
        let feed = storyboard?.instantiateViewControllerWithIdentifier("FeedScene") as! FeedViewController
        feed.tabBarItem.image = UIImage(named: "feed")
        let settings = storyboard?.instantiateViewControllerWithIdentifier("SettingsScene") as! SettingsViewController
        settings.tabBarItem.image = UIImage(named: "settings")
        let map = storyboard?.instantiateViewControllerWithIdentifier("MapScene") as! MapViewController
        map.tabBarItem.image = UIImage(named: "map")
        let controllers = [feed, post, map, settings]
        
        self.viewControllers = controllers
        
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

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
