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
    
    private let database: DatabaseReference

    private let defaultResaurant: [String: Any]
    
    private var currentData: [String: Any] = [:]
    
    init() {
        FirebaseApp.configure()
        
        self.database = Database.database().reference()
        
        self.defaultResaurant = [
            "restaurantName": "sampleName",
            "yelpStarRating": 1,
            "location": "seattle",
            "description" : "sampleDescription",
            "image": "sampleURL",
            "posts": [["userName": "testUserName", "postContent" : "sampleContent"], ["userName2": "testUserName", "postContentsdasd" : "sampleCasdasdontent"]],
            "businessID": "sampleID"
        ]
    }
    
    @objc func addNewRestaurant(restaurantName: String, yelpStarRating: Int, location: String, description: String, imageURL: String, image: String, posts: [[String: String]], businessID: String){
        
        let restaurant: [String: Any] = [
            "restaurantName": restaurantName,
            "yelpStarRating": yelpStarRating,
            "location": location,
            "description" : description,
            "image": imageURL,
            "posts": posts,
            "businessID": businessID
        ]
        
        database.child(businessID).setValue(restaurant)
    }
    
    //Use this function to set the accssed value to the currentData property.
    //This function does not return any value.
    
    
    func getValue(_ Key: String) -> [String: Any]{
        readEntry(Key)
        
        return currentData
    }
    
    private func readEntry(_ Key: String){
        database.child(Key).observeSingleEvent(of: .value, with: { snapshot in guard let value = snapshot.value as? [String: Any] else {
                print("INVALID KEY")
            return
            }
            self.currentData = value
        })
    }
}
