//
//  BusinessDetailsViewController.swift
//  DubFood
//
//  Created by Christopher Ku on 5/31/22.
//

import Foundation
import UIKit

class BusinessDetailsViewController: UIViewController {
        
    @IBOutlet weak var business_img: UIImageView!
    @IBOutlet weak var descr: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var restaurant_name: UILabel!
    @IBOutlet weak var add_comment: UIImageView!
    
    var business_id : String? =  "WavvLdfdP6g8aZTtbBQHTw" // replace with business id here
    let clientId = "PgR7zDES_S3gZbpGOzvF2w"
    let apiKey = "QvwuJuZIJFcStTAh3Cm44PDXrSV-yz402FVhGzwCZIb_8y5ieuEVTi5kuDsoY4O-mcJLWzTrg7k023x7jV4mgxBDZBW9JwoyB2UfaJRWZYpDMpohOcKRBe215guMYnYx"
    let business_id_url = "https://api.yelp.com/v3/businesses/"
    var business_details : Details? = nil

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
//                image?.size.width = self.business_img.frame.width
//                image?.size.height = self.business_img.frame.height
                self.business_img.image = self.resizeImage(image: image!, targetSize: CGSize(width: self.business_img.frame.width, height: self.business_img.frame.height))
            }
        }.resume()
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
