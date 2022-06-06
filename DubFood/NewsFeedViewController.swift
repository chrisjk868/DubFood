//
//  NewsFeedViewController.swift
//  DubFood
//
//  Created by Maxwell London on 6/6/22.
//

import UIKit

class NewsFeedViewController: UIViewController {

    var db : FirebaseInterface = FirebaseInterface()
    
    var currentPosts: NSDictionary = [:]
    override func viewDidLoad() {
        super.viewDidLoad()

        getPosts { rest_arr in
            if rest_arr == nil {
                print("POSTS RETURNED NIL")
                return
            }
            print(rest_arr)
        }
    }

    

    func getPosts(completion: @escaping (NSDictionary?) -> Void) {
        self.db.readEntry() { data, response in
            if data == nil {
                print("Data is nil")
                print(response!)
                completion(nil)
                return
            }
            let rest_dict = data as! NSDictionary
            let rest_arr = rest_dict["restaurants"] as! NSDictionary
    
            completion(rest_arr)
        }
    }


}





//extension NewsFeedViewController : UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return curr_posts!.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = usr_posts.dequeueReusableCell(withIdentifier: "userPostCell") as! PostsTableViewCell
////        cell.username.text = curr_posts![indexPath.row]["username"]
////        cell.postTitle.text = curr_posts![indexPath.row]["title"]
////        cell.postContent.text = curr_posts![indexPath.row]["content"]
////        print()
////        cell.rating = Int(curr_posts![indexPath.row]["post-rating"]!)!
////        cell.updateRating()
////        cell.selectionStyle = .none
////        return cell
//    }
//
//}
