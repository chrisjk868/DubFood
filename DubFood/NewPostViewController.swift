//
//  NewPostViewController.swift
//  DubFood
//
//  Created by iguest on 6/2/22.
//

import UIKit
//import FirebaseCore
//import FirebaseDatabase

class NewPostViewController: UIViewController {

    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var postContentTxtField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var postBtn: UIButton!
    
    let business_id_url = "https://api.yelp.com/v3/businesses/"
    var curr_user = "TestUser" // Change this to current user
    var business_name = ""
    var business_id = "" // Change this to the current business WavvLdfdP6g8aZTtbBQHTw
    var business_img = ""
    var rating = 0.0
    var post : [String:String] = ["":""]
    var db : FirebaseInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postTitle.borderStyle = UITextField.BorderStyle.roundedRect
        self.postContentTxtField.borderStyle = UITextField.BorderStyle.roundedRect

        // Do any additional setup after loading the view.
        self.db = FirebaseInterface()
        self.db!.setValue(self.business_id)
        print(self.business_name)
        print(self.business_id)
        print(self.business_img)
        print(self.rating)
    }
    
    func writePostToDB() {
        self.post = [
            "username": self.curr_user,
            "title": self.postTitle.text!,
            "content": self.postContentTxtField.text!
        ]

        self.existence(id : self.business_id) { exists, key in
            if exists {
                print("found restaurant")
                // Append to existing restaurant posts array
                // Get existing posts for current restaurant
                self.getCurrentPosts(indexKey: key!) { postsArr, indexKey, reponse in
                    if postsArr == nil {
                        print("couldn't get posts")
                        return
                    } else {
                        let curr_posts = postsArr!
                        curr_posts.add(self.post)
                        print(postsArr!)
                        self.db!.database.child("restaurants/\(indexKey)").updateChildValues(["posts": curr_posts])
                    }
                }
                
            } else {
                print("restaurant doesn't exist")
                // Add new restaurant and append new post to its posts array
                // Remember to update posts before writing to db
                self.db!.addNewRestaurant(
                    business_name: self.business_name,
                    business_id: self.business_id,
                    business_img: self.business_img,
                    rating: self.rating,
                    posts: [self.post]
                )
            }
        }
    }
    
    func existence(id: String, completion: @escaping (Bool, String?) -> Void) {
        self.db!.readEntry("restaurants") { data, response in
            if data == nil {
                print("Data is nil")
                print(response!)
                return
            }
            var index = 0
            var return_false = true
            let restaurants_data = data as! NSDictionary
            let restaurants = restaurants_data["restaurants"]!
            for restaurant in (restaurants as! [NSDictionary]) {
                let business_id = restaurant["business_id"] as! String
                print(business_id)
                if business_id == id {
                    return_false = false
                    print(String(index))
                    completion(true, String(index))
                }
                index += 1
            }
            if return_false {
                completion(false, nil)
            }
        }
    }
    
    
    func getCurrentPosts(indexKey: String, completion: @escaping (NSMutableArray?, String, String?) -> Void) {
        self.db!.readEntry("restaurants") { data, response in
            if data == nil {
                print("Data is nil")
                print(response!)
                completion(nil, indexKey, "failure")
                return
            }
            let rest_dict = data as! NSDictionary
            let identified_rest = rest_dict["restaurants"] as? NSArray
//            print(identified_rest![Int(indexKey)!])
            let rest_obj = identified_rest![Int(indexKey)!] as! NSDictionary
            let postsArr = rest_obj["posts"] as! NSMutableArray
            completion(postsArr, indexKey, "success")
        }
    }
    
    @IBAction func cancelBtnTap(_ sender: Any) {
        self.postTitle.text = ""
        self.postContentTxtField.text = ""
        self.performSegue(withIdentifier: "backToBusiness", sender: self)
    }
    
    @IBAction func postBtnTap(_ sender: Any) {
        
        if !postTitle.hasText || !postContentTxtField.hasText {
            let alert = UIAlertController(title: "Didn't Enter Title or Content", message: "Please enter a title and post", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                    case .default:
                    print("default")
                    case .cancel:
                    print("cancel")
                    case .destructive:
                    print("destructive")
                @unknown default:
                    print("unknown")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.writePostToDB()
            self.performSegue(withIdentifier: "backToBusiness", sender: self)
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "backToBusiness" {
            let vc = segue.destination as! BusinessDetailsViewController
            
        }
    }
}
