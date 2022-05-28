//
//  ViewController.swift
//  DubFood
//
//  Created by Christopher Ku on 5/24/22.
//

import UIKit

class ViewController: UIViewController {
    
    let url = "https://api.yelp.com/v3"
    let clientId = "PgR7zDES_S3gZbpGOzvF2w"
    let apiKey = "QvwuJuZIJFcStTAh3Cm44PDXrSV-yz402FVhGzwCZIb_8y5ieuEVTi5kuDsoY4O-mcJLWzTrg7k023x7jV4mgxBDZBW9JwoyB2UfaJRWZYpDMpohOcKRBe215guMYnYx"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Endpoints
        let business_endpoint = "/businesses/search"
        
        // Calling the Yelp API Business Endpoint
        var lat_long = "?latitude=47.602420&longitude=-122.392820"
        var location = "?location=Seattle"
        var request = URLRequest(url: URL(string: url + business_endpoint + location)!)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!)
                print(json)
            } catch {
                print(error)
                return
            }
            
        }.resume()
        
    }

    func makeRequest(){
        let appSecret = "QvwuJuZIJFcStTAh3Cm44PDXrSV-yz402FVhGzwCZIb_8y5ieuEVTi5kuDsoY4O-mcJLWzTrg7k023x7jV4mgxBDZBW9JwoyB2UfaJRWZYpDMpohOcKRBe215guMYnYx"
        let test = YelpBusinessSearch(latitude: "47.655548", longitude: "-122.303200", radius: "", categories: [""])
        var url : String = test.searchByLatLong()
        
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("Bearer \(appSecret)", forHTTPHeaderField: "Authorization")
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
        
                //let location = value[0] as! NSDictionary
                
                for i in value{
                    let location = i as! NSDictionary
                    
                    businessList.append(location.value(forKey: "id")! as! String)
                }
                
                DispatchQueue.main.async {
                    self.businesses = businessList
                    print(self.businesses)
                }
            } catch {
                print("error: \(error)")
            }
        }
        task.resume()
    }

    
    
}

