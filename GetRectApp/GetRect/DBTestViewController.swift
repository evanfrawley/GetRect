//
//  DBTestViewController.swift
//  GetRect
//
//  Created by Nick Nordale on 5/21/16.
//  Copyright © 2016 iGuest. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class DBTestViewController: UIViewController {
    
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginSubmit: UIButton!
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var songField: UITextField!
    @IBOutlet weak var postSubmit: UIButton!
    
    @IBAction func newPostEdit(sender: AnyObject) {
        if titleField.text != "" && songField.text != "" {
            postSubmit.userInteractionEnabled = true
        }
    }
    
    @IBAction func loginFunc(sender: AnyObject) {
        FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passwordField.text!) { (user, error) in
            if error != nil {
                let alertController : UIAlertController = UIAlertController(title: "Error", message: "Problem authenticating user", preferredStyle: .Alert)
                let okAction : UIAlertAction = UIAlertAction(title: "Ok", style: .Default, handler: self.dismissAlert)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func newPostFunc(sender: AnyObject) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").child(userID!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            self.writeNewPost(userID!, title: self.titleField.text!, song: self.songField.text!)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func writeNewPost(userID: String, title: String, song: String) {
        let key = ref.child("posts").childByAutoId().key
        let post = ["uid": userID,
                    "title": title,
                    "song": song]
        let childUpdates = ["/posts/\(key)": post,
                            "/user-posts/\(userID)/\(key)/": post]
        ref.updateChildValues(childUpdates)
        print(childUpdates)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        postSubmit.userInteractionEnabled = false
    }
    
    func dismissAlert(alert: UIAlertAction!) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
