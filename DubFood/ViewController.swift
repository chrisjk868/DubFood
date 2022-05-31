//
//  ViewController.swift
//  DubFood
//
//  Created by Christopher Ku on 5/24/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let url = "https://api.yelp.com/v3"
    let clientId = "PgR7zDES_S3gZbpGOzvF2w"
    let apiKey = "QvwuJuZIJFcStTAh3Cm44PDXrSV-yz402FVhGzwCZIb_8y5ieuEVTi5kuDsoY4O-mcJLWzTrg7k023x7jV4mgxBDZBW9JwoyB2UfaJRWZYpDMpohOcKRBe215guMYnYx"
    let business_endpoint = "/businesses/search"
    var businesses : Any? = nil
    var location = (0.0, 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Calling the Yelp API Business Endpoint
        makeRequest(coordinates: self.location)
    }

    func makeRequest(coordinates : (Double, Double)) {
        print("started making requests")
        let test = YelpBusinessSearch(latitude: String(coordinates.0), longitude: String(coordinates.1), radius: "", categories: [""])
        let url : String = test.searchByLatLong()
        print(url)
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        var businessList: [String] = []
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in guard let data = data else {
                print("data is nil")
                return
            }
            do {
                let data = try JSONSerialization.jsonObject(with: data) as! NSDictionary
        
                let value = data.value(forKey: "businesses") as! NSArray
                
                for i in value{
                    let location = i as! NSDictionary
                    businessList.append(location.value(forKey: "id")! as! String)
                }
                
                DispatchQueue.main.async {
                    self.businesses = businessList
                    print("businesses: \(self.businesses!)")
                }
            } catch {
                print("error: \(error)")
            }
        }
        task.resume()
    }

    
    
}

