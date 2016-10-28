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
import SwiftKeychainWrapper

class FeedVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImageView: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
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
            
            self.tableView.reloadData()
        })
    }
    
    //MARK: IBActions
    @IBAction func addImagePressed(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
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
}

//MARK: UITableView
extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as? FeedCell {
            cell.configureCell(post: post)
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
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
