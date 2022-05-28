//
//  YelpBusinessSearch.swift
//  DubFood
//
//  Created by Christopher Ku on 5/28/22.
//

import Foundation

class YelpBusinessSearch {

    let rootURL = "https://api.yelp.com/v3"

    var location: String?
    
    var latitude: String?
    
    var longitude: String?
    
    var radius: String?
    
    var categories: [String]?
    
    //TODO Implement user class
    //var user: User
    
    init(latitude: String?, longitude: String?, radius: String?, categories: [String]?) {
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.categories = categories
    }
    
    init(_ location: String?, radius: String?, categories: [String]?) {
        self.location = location
        self.radius = radius
        self.categories = categories
    }
//    func searchByLocation() -> {
//        if user.University != nil {
//            return user.University
//        }
//    }
    
    // business search path: /business/{id}
    func businessRequest(_ businessID: String) -> String {
        return "\(rootURL)/businesses/\(businessID)"
    }
    
    // business details
    func searchByLatLong() -> String{
        if latitude != nil && longitude != nil {
            let path = "/businesses/search?"
            
            let lat_long = "latitude=\(self.latitude!)&longitude=\(self.longitude!)"
            
            return rootURL + path + lat_long
        } else {
            //searchByLocation()
            return ""
        }
    }
}

    

//location, latitude longnitude, categories, radius
//


//import Foundation
//
//let appID = ""
//let appSecret = "QvwuJuZIJFcStTAh3Cm44PDXrSV-yz402FVhGzwCZIb_8y5ieuEVTi5kuDsoY4O-mcJLWzTrg7k023x7jV4mgxBDZBW9JwoyB2UfaJRWZYpDMpohOcKRBe215guMYnYx"
//let lat_long = "latitude=47.655548&longitude=-122.303200"
//let location = "location=Seattle"
//let rootURL = "https://api.yelp.com/v3/businesses/search?\(lat_long)"
//
//
//var request = URLRequest(url: URL(string: rootURL)!)
//request.setValue("Bearer \(appSecret)", forHTTPHeaderField: "Authorization")
//request.httpMethod = "GET"
//
//
//let task = URLSession.shared.dataTask(with: request) {
//    (data, response, error) in guard let data = data else {
//        print("data is nil")
//        return
//    }
//    do {
//        let data = try JSONSerialization.jsonObject(with: data) as! NSDictionary
//
//        let value = data.value(forKey: "businesses") as! NSArray
//
//        let location = value[0] as! NSDictionary
//
//        print(location.value(forKey: "id")!)
//
//    } catch {
//        print(error)
//    }
//}
//
//
//task.resume()
