//
//  FeedCell.swift
//  social-app
//
//  Created by Jason Ngo on 2016-10-28.
//  Copyright © 2016 Jason Ngo. All rights reserved.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likesBtn: UIButton!
    
    var post: Post!
    var likesRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeBtnTapped))
        tap.numberOfTapsRequired = 1
        likesBtn.addGestureRecognizer(tap)
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        
        if img != nil {
            self.postImg.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("JASON: Unable to d/l image from URL")
                } else {
                    print("JASON: Image downloaded successsfuly")
                    
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                        }
                    }
                }
            })
        }
        
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            if let _ = snapshot.value as? NSNull {
                self.likesBtn.setImage(UIImage(named: "empty-heart"), for: .normal)
            } else {
                self.likesBtn.setImage(UIImage(named: "filled-heart"), for: .normal)
            }
        })
    }
    
    func likeBtnTapped() {
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            if let _ = snapshot.value as? NSNull {
                self.likesBtn.setImage(UIImage(named: "filled-heart"), for: .normal)
                self.post.changeLikes(shouldIncreaseLikes: true)
                self.likesRef.setValue(true)
            } else {
                self.likesBtn.setImage(UIImage(named: "empty-heart"), for: .normal)
                self.post.changeLikes(shouldIncreaseLikes: false)
                self.likesRef.removeValue()
            }
        })
    }
}
