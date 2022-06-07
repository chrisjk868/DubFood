//
//  NewsFeedViewController.swift
//  DubFood
//
//  Created by Maxwell London on 6/6/22.
//

import UIKit

class NewsFeedViewController: UIViewController {

    var db : FirebaseInterface = FirebaseInterface()
    
    var postsArr: [NSDictionary]? = []
    
    @IBOutlet var tableView: UITableView!
    
    
    
    var currentPosts: NSDictionary = [:]
   
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getPosts { rest_arr in
            if rest_arr == nil {
                print("POSTS RETURNED NIL")
                return
            }
            
            self.currentPosts = rest_arr!
            self.sortDates()
            self.updatePostUI(self.currentPosts)
        }
        tableView.reloadData()
    }
    
    func sortDates(){
    
    }

    func updatePostUI(_ rest_data: NSDictionary){
        let rest_array = rest_data.allValues as! [NSDictionary]
        
        var posts_arr: [NSArray] = []


        
        for rest in rest_array {
            posts_arr.append(rest.value(forKey: "posts") as! NSArray)
        }
       
        for curr_rest_post in posts_arr{
            for post in curr_rest_post {
                print(post)
                self.postsArr?.append(post as! NSDictionary)
            }
        }
        tableView.reloadData()
    }

    func getPosts(completion: @escaping (NSDictionary?) -> Void) {
        self.db.readEntry() { data, response in
            if data == nil {
                print("Data is nil")
                completion(nil)
                return
            }
            let rest_dict = data as! NSDictionary
            let rest_arr = rest_dict["restaurants"] as! NSDictionary
    
            completion(rest_arr)
        }
    }
}

extension NewsFeedViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArr!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userPostCell") as! PostsTableViewCell
        cell.username.text = postsArr![indexPath.row]["username"] as? String
        cell.postTitle.text = postsArr![indexPath.row]["title"] as? String
        cell.postContent.text = postsArr![indexPath.row]["content"] as? String
        print(Int(postsArr![indexPath.row]["post-rating"]! as! String))
        cell.rating = Int(postsArr![indexPath.row]["post-rating"]! as! String)!
        cell.dateTime.text = NSDate(timeIntervalSinceReferenceDate: Double(postsArr![indexPath.row]["time"]! as! String)!).description
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy HH:mm"
        let formattedDate = formatter.string(from: NSDate(timeIntervalSinceReferenceDate: Double(postsArr![indexPath.row]["time"]! as! String)!) as Date)
        
        cell.dateTime.text = formattedDate
        
        cell.updateRating()
        cell.selectionStyle = .none
        return cell
    }
    
}


