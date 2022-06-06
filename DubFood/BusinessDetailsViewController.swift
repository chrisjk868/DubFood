//
//  BusinessDetailsViewController.swift
//  DubFood
//
//  Created by Christopher Ku on 5/31/22.
//

import Foundation
import UIKit
import SwiftUI

class BusinessDetailsViewController: UIViewController {
        
    @IBOutlet weak var image_scroller: UICollectionView!
    @IBOutlet weak var page_controller: UIPageControl!
    @IBOutlet weak var star_rating: UIStackView!
    @IBOutlet weak var descr: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var restaurant_name: UILabel!
    @IBOutlet weak var add_comment: UIImageView!
    @IBOutlet weak var usr_posts: UITableView!
    @IBOutlet var userRating: UIStackView!
    
    var business_details : Details? = nil
    var business_id : String? =  "WavvLdfdP6g8aZTtbBQHTw" // replace with business id here
    let clientId = "PgR7zDES_S3gZbpGOzvF2w"
    let apiKey = "QvwuJuZIJFcStTAh3Cm44PDXrSV-yz402FVhGzwCZIb_8y5ieuEVTi5kuDsoY4O-mcJLWzTrg7k023x7jV4mgxBDZBW9JwoyB2UfaJRWZYpDMpohOcKRBe215guMYnYx"
    let business_id_url = "https://api.yelp.com/v3/businesses/"
    
    // icons
    let star_full = UIImage(systemName: "star.fill")
    let star_half = UIImage(systemName: "star.leadinghalf.filled")
    let star_empty = UIImage(systemName: "star")
    
    // business images
    var img_url_arr : [String]? = ["https://s3-media2.fl.yelpcdn.com/bphoto/CPc91bGzKBe95aM5edjhhQ/o.jpg"]
    
    // auto scroll timer
    var timer : Timer?
    var currentCellIndex = 0
    
    // database
    var db : FirebaseInterface?
    
    // posts data
    var curr_posts : [[String : String]]? = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.usr_posts.delegate = self
        self.usr_posts.dataSource = self
        self.db = FirebaseInterface()
        self.add_comment.isUserInteractionEnabled = true
        let create_post_tap = UITapGestureRecognizer(target: self, action: #selector(createPost(_:)))
        self.add_comment.addGestureRecognizer(create_post_tap)
        getPosts(id: self.business_id!) { postsArr, response in
            if postsArr == nil {
                print(response)
                print("Didn't get posts")
                return
            }
            print(response)
            self.curr_posts = postsArr as? [[String : String]]
            self.usr_posts.reloadData()
        }
        makeDetailsRequest()
        // moved timer
//        self.image_scroller.layer.cornerRadius = 10
        self.page_controller.numberOfPages = self.img_url_arr!.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPosts(id: self.business_id!) { postsArr, response in
            if postsArr == nil {
                print(response)
                print("Didn't get posts")
                return
            }
            print(response)
            
            self.curr_posts = postsArr as? [[String : String]]
            self.calculateUserAverage(self.curr_posts!)
            self.usr_posts.reloadData()
        }
    }
    
    func calculateUserAverage(_ posts: [[String: String]]) -> Double{
        var count = 0.0
        
        if(posts.count == 0){
            return 0.0
        }

        for post in posts{
            count += Double(post["post-rating"]!)!
        }
        
        let average: Double = count / Double(posts.count)
        
        return average
    }
    
    override open var shouldAutorotate: Bool {
            return false
    }
    
    func makeDetailsRequest() {
        var request = URLRequest(url: URL(string: self.business_id_url + self.business_id!)!)
        request.setValue("Bearer \(self.apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in guard let data = data else {
                print("data is nil")
                return
            }
            
            do {
                let details = try JSONDecoder().decode(Details.self, from: data)
                self.business_details = details
                self.img_url_arr = details.photos
                DispatchQueue.main.async {
                    if self.img_url_arr!.count > 1 {
                        self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.slideToNext), userInfo: nil, repeats: true)
                    }
                    self.image_scroller.reloadData()
                    self.page_controller.numberOfPages = self.img_url_arr!.count
                    self.restaurant_name.text = self.business_details?.name!
                    self.location.text = self.business_details?.location?.displayAddress.joined(separator: ", ")
                    self.descr.text = self.updateDescr()
                    self.updateRating(rating: (self.business_details?.rating)!, starStackView: self.star_rating)
                    
                    let averageUserRating = self.calculateUserAverage(self.curr_posts!)
                    self.updateRating(rating: averageUserRating, starStackView: self.userRating)
                }
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }
    
    func updateRating(rating: Double, starStackView: UIStackView) {
        var full_stars = Int(rating)
        var half_stars = rating.truncatingRemainder(dividingBy: 1.0)
        
        // Iterate over stars stack view
        var star_index = 1
        for item in starStackView.arrangedSubviews {
            if item is UILabel {
                continue
            } else {
                item.isHidden = true
                if full_stars > 0 {
                    let full_star_view = UIImageView(image: self.star_full)
                    full_star_view.tintColor = .systemBlue
                    full_star_view.frame = CGRect(x: 0, y: 0, width: 22, height: 14)
                    starStackView.insertArrangedSubview(full_star_view, at: star_index)
                    full_stars -= 1
                } else {
                    if half_stars > 0 {
                        let half_star_view = UIImageView(image: self.star_half)
                        half_star_view.tintColor = .systemBlue
                        half_star_view.frame = CGRect(x: 0, y: 0, width: 22, height: 14)
                        starStackView.insertArrangedSubview(half_star_view, at: star_index)
                        half_stars -= 1
                    } else {
                        let empty_star_view = UIImageView(image: self.star_empty)
                        empty_star_view.tintColor = .systemBlue
                        empty_star_view.frame = CGRect(x: 0, y: 0, width: 22, height: 14)
                        starStackView.insertArrangedSubview(empty_star_view, at: star_index)
                    }
                }
                star_index += 1
            }
        }
        
    }
    
    
    func updateDescr() -> String {
        let categories = self.business_details?.categories
        var descr = ""
        for category_obj in categories! {
            descr += category_obj.title + " "
        }
        return descr
    }
    
    func getPosts(id : String, completion: @escaping (NSArray?, String) -> Void) {
        self.db!.readEntry() { data, response in
            if data == nil {
                print("Data is nil")
                print(response!)
                completion(nil, "Couldn't get posts or no posts")
                return
            }
            let rest_dict = data as! NSDictionary
            let rest_arr = rest_dict["restaurants"] as! NSDictionary
            var posts_arr : NSArray?
            for (rest_key, rest) in rest_arr {
                if  rest_key as! String == self.business_id! {
                    posts_arr = (rest as AnyObject).value(forKey: "posts") as? NSArray
                    completion(posts_arr, "Got Posts for restaurant \(self.business_id!)")
                }
            }
        }
    }
    
    @objc func slideToNext() {
        if self.currentCellIndex < self.img_url_arr!.count - 1  {
            self.currentCellIndex += 1
        } else {
            self.currentCellIndex = 0
        }
        
        self.page_controller.currentPage = self.currentCellIndex
        
        self.image_scroller.scrollToItem(at: IndexPath(item: self.currentCellIndex, section: 0), at: .right, animated: true)
    }
    
    @objc func createPost(_ sender: UITapGestureRecognizer) {
        print("tapped create post")
//        self.performSegue(withIdentifier: "post", sender: self)
        let new_post_vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newPost") as! NewPostViewController
        new_post_vc.business_name = (self.business_details?.name)!
        new_post_vc.business_id = (self.business_details?.id)!
        new_post_vc.business_img = (self.business_details?.imageURL)!
        new_post_vc.rating = (self.business_details?.rating)!
        self.navigationController?.pushViewController(new_post_vc, animated: true)
    }
    
//    @IBAction func backBtnClick(_ sender: Any) {
//        self.performSegue(withIdentifier: "toExplore", sender: self)
//    }
    
    // MARK: - Navigation

/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "post" {
            let vc = segue.destination as! NewPostViewController
            vc.business_name = (self.business_details?.name)!
            vc.business_id = (self.business_details?.id)!
            vc.business_img = (self.business_details?.imageURL)!
            vc.rating = (self.business_details?.rating)!
            // For testing
//            vc.business_name = "Test Restaurant"
//            vc.business_id = "Test Restaurant ID"
//            vc.business_img = "Test Restaurant IMG"
//            vc.rating = 5.0
        }
    }
*/
}

extension BusinessDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.img_url_arr!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        // replace with business images
        if let url = URL(string: self.img_url_arr![indexPath.row]) {
            cell.business_img.isDetails = true
            cell.business_img.loadImage(url: url)
            cell.makeRounded()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.image_scroller.frame.width, height: self.image_scroller.frame.height)
    }
    
}

extension BusinessDetailsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return curr_posts!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usr_posts.dequeueReusableCell(withIdentifier: "userPostCell") as! PostsTableViewCell
        cell.username.text = curr_posts![indexPath.row]["username"]
        cell.postTitle.text = curr_posts![indexPath.row]["title"]
        cell.postContent.text = curr_posts![indexPath.row]["content"]
        print()
        cell.rating = Int(curr_posts![indexPath.row]["post-rating"]!)!
        cell.updateRating()
        cell.selectionStyle = .none
        return cell
    }
    
}
