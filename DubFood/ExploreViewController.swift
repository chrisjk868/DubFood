//
//  ViewController.swift
//  DubFood
//
//  Created by Christopher Ku on 5/24/22.
//

import UIKit
import CoreLocation
import CloudKit

class ExploreViewController: UIViewController {
    
    @IBOutlet weak var restaurants_view: UITableView!
    
    let url = "https://api.yelp.com/v3"
    let clientId = "PgR7zDES_S3gZbpGOzvF2w"
    let apiKey = "QvwuJuZIJFcStTAh3Cm44PDXrSV-yz402FVhGzwCZIb_8y5ieuEVTi5kuDsoY4O-mcJLWzTrg7k023x7jV4mgxBDZBW9JwoyB2UfaJRWZYpDMpohOcKRBe215guMYnYx"
    let business_endpoint = "/businesses/search"
    var business_ids : Any? = nil
    var business_arr : [NSDictionary]?
    var location = (47.66263, -122.306852) // Replace with user coordinates
    var selected_business_id = ""
    var filters :[String]? = []
    var radiusVal : String = "16090"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Calling the Yelp API Business Endpoint
        restaurants_view.delegate = self
        restaurants_view.dataSource = self
        makeRequest(coordinates: self.location)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // delay
            print("2 sec delay")
            self.makeRequest(coordinates: self.location)
        }
        
        print("====================view about to appear========")
        print(filters)
        print(radiusVal)
        
        
        // debugging delay

        
    }

    func makeRequest(coordinates : (Double, Double)) {
        print("started making requests")
        let test = YelpBusinessSearch(latitude: String(coordinates.0), longitude: String(coordinates.1), radius: radiusVal, categories: filters)
        let url : String = test.searchByLatLong()
        print(url)
        var request = URLRequest(url: URL(string: url) ?? URL(string: "https://api.yelp.com/v3/businesses/search?latitude=\(coordinates.0)&longitude=\(coordinates.1)")!)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        var businessList: [String] = []

        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in guard let data = data else {
                print("data is nil")
                return
            }
            do {
                print("response: \((response! as! HTTPURLResponse).statusCode)")
                if (response! as! HTTPURLResponse).statusCode == 200 {
                    let data = try JSONSerialization.jsonObject(with: data) as! NSDictionary
                    print("url: \(url)")
                    print("data: \(data)")
                    let value_arr = data.value(forKey: "businesses") as! [NSDictionary]
                    let value = data.value(forKey: "businesses") as! NSArray

                    for i in value {
                        let location = i as! NSDictionary
                        businessList.append(location.value(forKey: "id")! as! String)
                    }
                    DispatchQueue.main.async {
                        self.business_ids = businessList
                        // Finished updateing business array
                        self.business_arr = value_arr
                        // Update table view
                        print(self.restaurants_view)
                        self.restaurants_view.reloadData()
                    }
                }
                
            } catch {
                print("error: \(error)")
            }
        }
        task.resume()
    }
    
    func printFilters() {
        print(filters)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDetails" {
//            let vc = segue.destination as! BusinessDetailsViewController
//            vc.business_id = selected_business_id
//        }
//    }
}

extension ExploreViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return business_arr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = restaurants_view.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as! RestaurantTableViewCell
        let restaurant = business_arr?[indexPath.row]
        let location_obj = restaurant!.value(forKey: "location") as! NSDictionary
        let display_address = "\(location_obj.value(forKey: "address1") as? String ?? ""), \(location_obj.value(forKey: "city") as! String), \(location_obj.value(forKey: "state") as! String)"
        print(display_address)
        var priceString = "$$$"
        var priceLvl = priceString.count
        if restaurant?.value(forKey: "price") != nil {
            priceString = restaurant?.value(forKey: "price") as! String
            priceLvl = priceString.count
        }
        cell.restaurantImg.isDetails = false
        cell.restaurantImg.loadImage(url: URL(string: restaurant?.value(forKey: "image_url") as! String)!)
        cell.restaurantName.text = (restaurant?.value(forKey: "name") as! String)
        cell.restaurantLoc.text = display_address
        cell.updatePriceLvl(priceLvl: priceLvl)
        cell.launched += 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected_business_id = business_arr?[indexPath.row].value(forKey: "id") as! String
//        self.performSegue(withIdentifier: "toDetails", sender: self)
        let details_vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "restDetails") as! BusinessDetailsViewController
        details_vc.business_id = selected_business_id
        self.navigationController?.pushViewController(details_vc, animated: true)
    }
    
}

