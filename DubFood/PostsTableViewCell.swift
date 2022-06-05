//
//  PostsTableViewCell.swift
//  DubFood
//
//  Created by Christopher Ku on 6/4/22.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        postView.layer.cornerRadius = postView.frame.height / 4
        userImage.layer.cornerRadius = userImage.frame.height / 2.5
        userImage.backgroundColor = .white
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
