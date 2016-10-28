//
//  DataService.swift
//  social-app
//
//  Created by Jason Ngo on 2016-10-28.
//  Copyright © 2016 Jason Ngo. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()

class DataService {
    static let ds = DataService()
    
    private let _REF_BASE = DB_BASE
    private let _REF_POSTS = DB_BASE.child("posts")
    private let _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
