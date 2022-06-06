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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Calling the Yelp API Business Endpoint
        restaurants_view.delegate = self
        restaurants_view.dataSource = self
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
                    self.restaurants_view.reloadData()
                }
            } catch {
                print("error: \(error)")
            }
        }
        task.resume()
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
        let display_address = "\(location_obj.value(forKey: "address1") as! String), \(location_obj.value(forKey: "city") as! String), \(location_obj.value(forKey: "state") as! String)"
        let priceString = restaurant?.value(forKey: "price") as! String
        let priceLvl = priceString.count
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

