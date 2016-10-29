//
//  FeedVC.swift
//  social-app
//
//  Created by Jason Ngo on 2016-10-27.
//  Copyright © 2016 Jason Ngo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class FeedVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var captionField: ShadowField!
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) -> Void in
            
            self.posts = []
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    let post = Post(key: snap.key, data: snap)
                    self.posts.append(post)
                }
            }
            
            self.posts.reverse()
            self.tableView.reloadData()
        })
    }
    
    //MARK: IBActions
    @IBAction func addImagePressed(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postBtnPressed(_ sender: AnyObject) {
        guard let caption = captionField.text, caption != "" else {
            print("JASON: Caption does not contain any text")
            return
        }
        
        guard let img = addImageView.image, imageSelected == true else {
            print("JASON: Did not add an image")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUID = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUID).put(imgData, metadata: metadata, completion: { (metadata, error) in
                if error != nil {
                    print("JASON: Unable to upload image to Firebase storage")
                } else {
                    print("JASON: Successfully uploaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imgURL: url)
                    }
                }
            })
        }
    }
    
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
    
    func postToFirebase(imgURL: String) {
        let post: Dictionary<String, Any> = [
            "caption" : captionField.text!,
            "imageURL" : imgURL,
            "likes" : 0
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        addImageView.image = UIImage(named: "add-image")
        
        self.tableView.reloadData()
    }
}

//MARK: UITableView
extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as? FeedCell {
            if let img = FeedVC.imageCache.object(forKey: post.imageURL as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            
            return cell
        } else {
            return FeedCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

}

//MARK: UIImagePicker
extension FeedVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImageView.image = image
            imageSelected = true
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
