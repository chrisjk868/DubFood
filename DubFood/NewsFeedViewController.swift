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
    
    
    
    var currentPosts: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("hello world")
        viewLoadSetup()

     }
    
    func viewLoadSetup(){
        getPosts { rest_arr in
            if rest_arr == nil {
                print("POSTS RETURNED NIL")
                return
            }
            
            var convertedArrayDict: [NSDictionary] = []
            
            for key in rest_arr!.allKeys{
                let rest = (rest_arr?.value(forKey: key as! String) as! NSDictionary)
                
                let value = rest.value(forKey: "posts") as! NSArray
                
                if(value.count > 1){
                    for post in value{
                        convertedArrayDict.append(post as! NSDictionary)
                    }
                } else {
                    convertedArrayDict.append(value[0] as! NSDictionary)
                }
                
            }
            
            self.currentPosts = convertedArrayDict
            self.updatePostUI(self.sortDates())
        }
    }
    
    func sortDates() -> [NSDictionary]{
        
        let orderedPosts = currentPosts.sorted(by: {postSort(p1: $0, p2: $1)})
        
        return orderedPosts
    }
    
    func postSort(p1:NSDictionary, p2:NSDictionary) -> Bool {
        guard let s1 = Double(p1.value(forKey: "time") as! Substring), let s2 = Double(p2.value(forKey: "time") as! Substring) else {
            return false
        }
        
        if s1 == s2 {
            guard let g1 = Double(p1["time"]! as! Substring), let g2 = Double(p2["time"]! as! Substring) else {
                return false
            }
            return g1 > g2
        }
        
        return s1 > s2
    }
    
    func updatePostUI(_ rest_data: [NSDictionary]){
        for post in rest_data{
            postsArr?.append(post)
        }
        
        print(postsArr)
        
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


