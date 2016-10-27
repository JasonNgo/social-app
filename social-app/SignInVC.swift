//
//  SignInVC.swift
//  social-app
//
//  Created by Jason Ngo on 2016-10-26.
//  Copyright © 2016 Jason Ngo. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: segueToFeedVC, sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func emailSignInBtnPressed(_ sender: AnyObject) {
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                             print("JASON: Unable to authenticate email/password with Firebase - \(error)")
                        } else {
                            print("JASON: Email User authenticated with Firebase")
                            
                            if let user = user {
                                self.completeSignIn(withUser: user)
                            }
                        }
                    })
                } else {
                    print("JASON: Successfully authenticated with Firebase")
                    
                    if let user = user {
                        self.completeSignIn(withUser: user)
                    }
                }
            })
        }
    }
    
    @IBAction func facebookBtnPressed(_ sender: AnyObject) {
        let fbLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("JASON: Unable to authenticate with Facebook - \(error.debugDescription)\n")
            } else if result?.isCancelled == true {
                print("JASON: User cancelled Facebook authentication\n")
            } else {
                print("JASON: Successfully authenticate with Facebook\n")
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuthentication(with: credential)
            }
        }
    }
    
    func firebaseAuthentication(with credentials: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("JASON: Unable to authenticate with Firebase - \(error.debugDescription)\n")
            } else {
                print("JASON: Successfully authenticated with Firebase\n")
                
                if let user = user {
                    self.completeSignIn(withUser: user)
                }
            }
        })
    }
    
    func completeSignIn(withUser user: FIRUser) {
        let saveSuccessful: Bool = KeychainWrapper.standard.set(user.uid, forKey: KEY_UID)
        
        if saveSuccessful {
            print("JASON: Successfully saved uid to keychain")
        
            if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
                performSegue(withIdentifier: segueToFeedVC, sender: nil)
            }
        } else {
            print("JASON: Unable to save uid to keychain")
        }
    }
}

