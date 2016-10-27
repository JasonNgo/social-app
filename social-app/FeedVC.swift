//
//  FeedVC.swift
//  social-app
//
//  Created by Jason Ngo on 2016-10-27.
//  Copyright © 2016 Jason Ngo. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftKeychainWrapper

class FeedVC: UIViewController {
    
    @IBAction func signOutBtnPressed(_ sender: AnyObject) {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        
        if removeSuccessful {
            print("JASON: uid key removed from keychain")
        } else {
            print("JASON: uid key not removed from keychain")
        }
        
        try! FIRAuth.auth()?.signOut()
        self.dismiss(animated: true, completion: nil)

    }
}
