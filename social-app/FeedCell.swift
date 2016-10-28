//
//  FeedCell.swift
//  social-app
//
//  Created by Jason Ngo on 2016-10-28.
//  Copyright © 2016 Jason Ngo. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(post: Post) {
        self.post = post
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
    }

}
