//
//  Post.swift
//  social-app
//
//  Created by Jason Ngo on 2016-10-28.
//  Copyright © 2016 Jason Ngo. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _caption: String!
    private var _imageURL: String!
    private var _likes: Int!
    private var _postKey: String!
    
    var caption: String! {
        return _caption
    }
    
    var imageURL: String {
        return _imageURL
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String! {
        return _postKey
    }
    
    init(key: String, data: FIRDataSnapshot) {
        
        self._postKey = key
        
        if let dataDict = data.value as? Dictionary<String, Any> {
            if let caption = dataDict["caption"] as? String {
                self._caption = caption
            }
            
            if let imageURL = dataDict["imageURL"] as? String {
                self._imageURL = imageURL
            }
            
            if let likes = dataDict["likes"] as? Int {
                self._likes = likes
            }
        }
    }
}
