//
//  DataService.swift
//  social-app
//
//  Created by Jason Ngo on 2016-10-28.
//  Copyright © 2016 Jason Ngo. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    static let ds = DataService()
    
    // DB References
    private let _REF_BASE = DB_BASE
    private let _REF_POSTS = DB_BASE.child("posts")
    private let _REF_USERS = DB_BASE.child("users")
    
    // Storage References
    private let _STORAGE_BASE = STORAGE_BASE
    private let _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        
        return user
    }
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
