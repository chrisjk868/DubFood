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
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var load_spinner: UIActivityIndicatorView!
    @IBOutlet weak var starBtnOne: UIButton!
    @IBOutlet weak var starBtnTwo: UIButton!
    @IBOutlet weak var starBtnThree: UIButton!
    @IBOutlet weak var starBtnFour: UIButton!
    @IBOutlet weak var starBtnFive: UIButton!
    
    let business_id_url = "https://api.yelp.com/v3/businesses/"
    var curr_user = "TestUser" // Change this to current user
    var business_name = ""
    var business_id = "" // Change this to the current business WavvLdfdP6g8aZTtbBQHTw
    var business_img = ""
    var rating = 0.0
    var post : [String:String] = ["":""]
    var db : FirebaseInterface?
    var user_rating = 0
    
    var userInfo : [UserData] = []
    
    struct UserData: Codable {
        let username, email, university: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.load_spinner.isHidden = true
        self.postBtn.isEnabled = true
        self.postTitle.borderStyle = UITextField.BorderStyle.roundedRect
        self.postContentTxtField.borderStyle = UITextField.BorderStyle.roundedRect
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
        self.db = FirebaseInterface()
        print(self.business_name)
        print(self.business_id)
        print(self.business_img)
        print(self.rating)
        
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
             let pathWithFilename = documentDirectory.appendingPathComponent("userInfo.json")
             do {
                 let data = try Data(contentsOf: pathWithFilename)
                 let info = try JSONDecoder().decode(UserData.self, from: data)
                 self.userInfo = [info]
                 self.curr_user = self.userInfo[0].username
             } catch {
                 print("There was an error getting user data from the local file: \(error)")
             }
         }
        
    }
    
    override open var shouldAutorotate: Bool {
            return false
    }
    
    func writePostToDB() {
        self.post = [
            "username": self.curr_user,
            "title": self.postTitle.text!,
            "content": self.postContentTxtField.text!,
            "post-rating": String(self.user_rating),
            "time": String(NSDate().timeIntervalSinceReferenceDate)
        ]

        self.existence(id : self.business_id) { exists, key in
            if exists {
                print("found restaurant")
                // Append to existing restaurant posts array
                // Get existing posts for current restaurant
                self.getCurrentPosts(rest_id: key!) { postsArr, indexKey, reponse in
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
        self.db!.readEntry() { data, response in
            if data == nil {
                print("Data is nil")
                print(response!)
                return
            }
            var return_false = true
            let restaurants_data = data as! NSDictionary
            let restaurants = restaurants_data.value(forKey: "restaurants") as! NSDictionary
            let restaurant_keys = restaurants.allKeys as! [String]
            if restaurant_keys.contains(self.business_id) {
                
            }
            for (restaurant_key, restaurant) in restaurants {
                if self.business_id == restaurant_key as! String {
                    return_false = false
                    completion(true, restaurant_key as? String)
                }
            }
            if return_false {
                completion(false, nil)
            }
        }
    }
    
    
    func getCurrentPosts(rest_id: String, completion: @escaping (NSMutableArray?, String, String?) -> Void) {
        self.db!.readEntry() { data, response in
            if data == nil {
                print("Data is nil")
                print(response!)
                completion(nil, rest_id, "failure")
                print(rest_id)
                return
            }
            print(rest_id)
            let databse = data as! NSDictionary
            let identified_rest = databse["restaurants"] as? [String : NSDictionary]
//            print(identified_rest![Int(indexKey)!])
            let rest_obj = identified_rest![rest_id] as! NSDictionary
            let postsArr = rest_obj["posts"] as! NSMutableArray
            print(postsArr)
            completion(postsArr, rest_id, "success")
        }
    }
    
//    @IBAction func cancelBtnTap(_ sender: Any) {
//        self.postTitle.text = ""
//        self.postContentTxtField.text = ""
//        self.performSegue(withIdentifier:"backToBusiness",sender: self)
//        let details_vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "restDetails") as! BusinessDetailsViewController
//        details_vc.business_id = self.business_id
//        self.navigationController?.pushViewController(details_vc, animated: true)
//        self.navigationController?.popViewController(animated: true)
//    }
    
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
            self.postBtn.isEnabled = false
            self.load_spinner.isHidden = false
            self.load_spinner.startAnimating()
            self.writePostToDB()
            DispatchQueue.main.asyncAfter(deadline:.now() + 2.0, execute: {
                self.load_spinner.isHidden = true
                self.load_spinner.stopAnimating()
                
                // access & reload previous vc
//                if let navController = self.navigationController, navController.viewControllers.count >= 2 {
//                    let viewController = navController.viewControllers[navController.viewControllers.count - 2] as! BusinessDetailsViewController
//                    viewController.updateRating(rating: viewController.calculateUserAverage(viewController.curr_posts!), starStackView: viewController.userRating)
//                }
                
                // pop current vc
                self.navigationController?.popViewController(animated: true)
//                self.performSegue(withIdentifier:"backToBusiness",sender: self)
//                let details_vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "restDetails") as! BusinessDetailsViewController
//                details_vc.business_id = self.business_id
//                self.navigationController?.pushViewController(details_vc, animated: true)
            })
        }
        
    }

    @IBAction func fiveStarTapped(_ sender: UIButton) {
        self.user_rating = sender.tag
        let star_arr : [UIButton] = [starBtnOne, starBtnTwo, starBtnThree, starBtnFour, starBtnFive]
        for i in 0...4 {
            if i < sender.tag {
                star_arr[i].setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                star_arr[i].setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    
    // MARK: - Navigation
    
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "backToBusiness" {
            let vc = segue.destination as! BusinessDetailsViewController
            vc.business_id = self.business_id
        }
    }
 */
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
