//
//  User.swift
//  DubFood
//
//  Created by Amaya Kejriwal on 5/31/22.
//

import Foundation

class User {
    var username : String
    var email : String
    var university : String
    
    init(username un : String, email e : String, university u : String) {
        self.username = un
        self.email = e
        self.university = u
    }
    
}
