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

//    public let defaultResaurant: [String: Any]
    
    public let database: DatabaseReference
    public var currentData: Any?
    public static var isAlreadyLaunchedOnce = false
    
    init() {
        if !FirebaseInterface.isAlreadyLaunchedOnce {
            FirebaseApp.configure()
            FirebaseInterface.isAlreadyLaunchedOnce = true
        }
        self.database = Database.database().reference()
        self.currentData = nil
//        self.defaultResaurant = [
//            "restaurantName": "sampleName",
//            "yelpStarRating": 1,
//            "location": "seattle",
//            "description" : "sampleDescription",
//            "image": "sampleURL",
//            "posts": [["userName": "testUserName", "postContent" : "sampleContent"], ["userName2": "testUserName", "postContentsdasd" : "sampleCasdasdontent"]],
//            "businessID": "sampleID"
//        ]
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
            
            self.database.child("restaurants").observeSingleEvent(of: .value) { (snapshot) in
                let curr_restaurant_arr = snapshot.value as! NSMutableArray
                curr_restaurant_arr.add(new_restaurant_post)
                self.database.updateChildValues(["restaurants" : curr_restaurant_arr]) {
                    (error:Error?, ref:DatabaseReference) in
                    if error != nil {
                        print("Data couldn't be saved")
                    } else {
                        print("Data saved successfully")
                    }
                }
            }
            
    }
    
    //Use this function to set the accssed value to the currentData property.
    //This function does not return any value.
    //Use this as an example for making read requests from database.
    func setValue(_ Key: String) {
        self.readEntry(Key) { data, response in
            if data == nil {
                print("There was an error")
                print(response!)
                return
            }
            self.currentData = data
        }
    }

    
    func readEntry(_ Key: String, completion: @escaping (Any?, String?) -> Void ) {
        self.database.observeSingleEvent(of: .value, with: { snapshot in
            let data = snapshot.value as? NSDictionary
            completion(data, "success")
        }) { error in
            print(error.localizedDescription)
            completion(nil, "Error: \(error.localizedDescription)")
        }
        
    }
    
    //    func readEntry(_ Key: String, completion: @escaping (Any) -> Void){
    //        database.observeSingleEvent(of: .value, with: { snapshot in guard let value = snapshot.value as? [String: Any] else {
    //            print("INVALID KEY")
    //            completion(self.currentData!)
    //            return
    //            }
    //            self.currentData = value[Key]
    //            completion(self.currentData)
    //        })
    //    }
    
}
