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
    var timer:Timer?
    var currentCellIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        makeDetailsRequest()
        self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
        self.page_controller.numberOfPages = self.img_url_arr!.count
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
//                    print(self.img_url_arr)
                    self.image_scroller.reloadData()
                    self.page_controller.numberOfPages = self.img_url_arr!.count
                    self.restaurant_name.text = self.business_details?.name!
                    self.location.text = self.business_details?.location?.displayAddress.joined(separator: ", ")
                    self.descr.text = self.updateDescr()
                    self.updateRating()
                }
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }
    
    func updateRating() {
        let denominator = 2.0
        let stars = round((self.business_details?.rating)! * denominator) / denominator
        var full_stars = Int(floor(stars))
        var half_stars = Int((stars - Double(full_stars)) / 0.5)
        
        // Iterate over stars stack view
        var star_index = 1
        for item in self.star_rating.arrangedSubviews {
            if item is UILabel {
                continue
            } else {
                item.isHidden = true
                if full_stars > 0 {
                    let full_star_view = UIImageView(image: self.star_full)
                    full_star_view.tintColor = .systemBlue
                    full_star_view.frame = CGRect(x: 0, y: 0, width: 22, height: 15)
                    self.star_rating.insertArrangedSubview(full_star_view, at: star_index)
                    full_stars -= 1
                } else {
                    let half_star_view = UIImageView(image: self.star_half)
                    half_star_view.tintColor = .systemBlue
                    half_star_view.frame = CGRect(x: 0, y: 0, width: 22, height: 15)
                    self.star_rating.insertArrangedSubview(half_star_view, at: star_index)
                    half_stars -= 1
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func slideToNext() {
        if self.currentCellIndex < self.img_url_arr!.count - 1  {
            self.currentCellIndex += 1
        } else {
            self.currentCellIndex = 0
        }
        
        self.page_controller.currentPage = self.currentCellIndex
        
        self.image_scroller.scrollToItem(at: IndexPath(item: self.currentCellIndex, section: 0), at: .right, animated: true)
    }

}

extension BusinessDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.img_url_arr!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        // replace with business images
        if let url = URL(string: self.img_url_arr![indexPath.row]) {
            cell.business_img.loadImage(url: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.image_scroller.frame.width, height: self.image_scroller.frame.height)
    }
    
}
