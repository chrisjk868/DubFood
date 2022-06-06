//
//  FirebaseInterface.swift
//  DubFood
//
//  Created by Maxwell London on 5/31/22.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

class FirebaseInterface {
    
    public let database: DatabaseReference
    public static var isAlreadyLaunchedOnce = false
    
    init() {
        if !FirebaseInterface.isAlreadyLaunchedOnce {
            FirebaseApp.configure()
            FirebaseInterface.isAlreadyLaunchedOnce = true
        }
        self.database = Database.database().reference()
    }
    
    func addNewRestaurant(
        business_name: String,
        business_id: String,
        business_img: String,
        rating: Double,
        posts: [[String : String]]) {
        
            // Function Body:
            let new_restaurant_post: [String: Any] = [
                "business_name": business_name,
                "business_id": business_id,
                "business_img": business_img,
                "rating": rating,
                "posts": posts
            ]
            
            print(new_restaurant_post)
            
//            self.database.child("restaurants").observeSingleEvent(of: .value) { (snapshot) in
//                let curr_restaurant_arr = snapshot.value as! NSMutableArray
//                curr_restaurant_arr.add(new_restaurant_post)
//                self.database.updateChildValues(["restaurants" : curr_restaurant_arr]) {
//                    (error:Error?, ref:DatabaseReference) in
//                    if error != nil {
//                        print("Data couldn't be saved")
//                    } else {
//                        print("Data saved successfully")
//                    }
//                }
//            }
            
            self.database.child("restaurants/\(business_id)").setValue(new_restaurant_post)
            
    }
    
    func readEntry(completion: @escaping (Any?, String?) -> Void ) {
        self.database.observeSingleEvent(of: .value, with: { snapshot in
            let data = snapshot.value as? NSDictionary
            print(data)
            completion(data, "success")
        }) { error in
            print(error.localizedDescription)
            completion(nil, "Error: \(error.localizedDescription)")
        }
        
    }
    
}
