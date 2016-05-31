//
//  TabBarViewController.swift
//  GetRect
//
//  Created by Evan on 5/31/16.
//  Copyright © 2016 iGuest. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewWillAppear(animated: Bool) {
        
        let post = storyboard?.instantiateViewControllerWithIdentifier("PostScene") as! PostViewController
        let feed = storyboard?.instantiateViewControllerWithIdentifier("FeedScene") as! FeedViewController
        let settings = storyboard?.instantiateViewControllerWithIdentifier("SettingsScene") as! SettingsViewController
        
        let controllers = [post, feed, settings]
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
