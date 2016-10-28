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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
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

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        return tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

}
