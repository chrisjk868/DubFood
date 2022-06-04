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

    override func viewDidLoad() {
        super.viewDidLoad()
        makeDetailsRequest()
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
                DispatchQueue.main.async {
                    self.restaurant_name.text = self.business_details?.name!
                    self.location.text = self.business_details?.location?.displayAddress.joined(separator: ", ")
                    self.descr.text = self.updateDescr()
                    self.updateRating()
                    self.updateImage(
                        business_img: URL(string: (self.business_details?.imageURL)!)!)
                }
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }
    
    func updateImage(business_img : URL) {
        URLSession.shared.dataTask(with: business_img) {
            (data, response, error) in guard let data = data else {
                print("image data is nil")
                return
            }
            DispatchQueue.main.async {
                var image = UIImage(data: data)
//                self.business_img.image = self.resizeImage(image: image!, targetSize: CGSize(width: self.business_img.frame.width, height: self.business_img.frame.height))
            }
        }.resume()
    }
    
    func updateRating() {
        let denominator = 2.0
        let stars = round((self.business_details?.rating)! * denominator) / denominator
        var full_stars = Int(floor(stars))
        var half_stars = Int((stars - Double(full_stars)) / 0.5)
        
        // Iterate over stars stack view
        var star_index = 1
        for item in self.star_rating.arrangedSubviews {
            if let item_type = item as? UILabel {
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
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
