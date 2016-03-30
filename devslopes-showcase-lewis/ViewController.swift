//
//  ViewController.swift
//  devslopes-showcase-lewis
//
//  Created by Lewis Black on 29/03/2016.
//  Copyright © 2016 Lewis Black. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    @IBAction func fbBtnPressed(sender: UIButton!) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult:FBSDKLoginManagerLoginResult!, facebookError:NSError!) -> Void in
            
            if facebookError != nil {
                print("Facebook Login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("success is in the mind \(accessToken)")
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { (error, authData) in
                    
                    if error != nil {
                        print("Login failed. \(error)")
                    } else {
                        print("Logged In!\(authData)")
                        
                        let user = ["provider": authData.provider!, "blah":"test"]
                        DataService.ds.createFirebaseUser(authData.uid, user: user)
                        
                        
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
                    
                })
                
                
            }
            
        }
    }

    @IBAction func attemptLogin(sender: UIButton!) {
        
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                
                if error != nil {
                    
                    if error.code == STATUS_ACCOUNT_NONEXIST {
                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { (error, result) in
                            
                            if error != nil {
                                self.showErrorAlert("Could not create account", msg: "Problem creating account. God doesn't love you")
                            } else {
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                
                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: nil)
                                
                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { err, authData in
                                    
                                    let user = ["provider": authData.provider!, "blah":"emailtest"]
                                    DataService.ds.createFirebaseUser(authData.uid, user: user)
                                    
                                    
                                })
                                
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                                
                            }
                        
                        })
                    } else {
                        self.showErrorAlert("Could not log in", msg: "CHECK YOUR FUCKiNG PASSWORD")
                    }
                    
                    
                } else {
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
                
            })
            
        } else {
            showErrorAlert("Email and Password Required", msg: "DICK PUT A EMAIL AND PASSWORD IN!")
        }
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
}

