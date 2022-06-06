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
    @IBOutlet weak var postRating: UIStackView!
    
    var rating = 0
    
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
    
    func updateRating() {
        var fill = rating
        var empty = 5 - fill
        var index = 0
        for item in postRating.arrangedSubviews {
            item.isHidden = true
            if fill > 0 {
                let full_star_view = UIImageView(image: UIImage(systemName: "star.fill"))
                full_star_view.tintColor = .systemBlue
                full_star_view.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
                postRating.insertArrangedSubview(full_star_view, at: index)
                fill -= 1
            } else {
                if empty > 0 {
                    let empty_star_view = UIImageView(image: UIImage(systemName: "star"))
                    empty_star_view.tintColor = .systemBlue
                    empty_star_view.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
                    postRating.insertArrangedSubview(empty_star_view, at: index)
                    empty -= 1
                } else {
                    break
                }
            }
            index += 1
        }
    }

}
