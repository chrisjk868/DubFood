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

    init(){
        FirebaseApp.configure()
        
        self.database = Database.database().reference()
        
        let object: [String: String] = [
            "name": "test123",
            "class": "test123"
        ]
        
        addNewEntry(object: object, name: "testing")
        
        readEntry("testing")
    }
    
    
    //TODO, need to add parameter that takes NSObject
    @objc func addNewEntry(object: [String: String], name: String){
        database.child(name).setValue(object)
    }
    
    func readEntry(_ Key: String){
        database.child(Key).observeSingleEvent(of: .value, with: { snapshot in guard let value = snapshot.value as? [String: Any] else {
                print("INVALID KEY")
                return
            }
            print(value)
        })
    }
}
