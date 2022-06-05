//
//  UserProfileViewController.swift
//  DubFood
//
//  Created by Amaya Kejriwal on 5/31/22.
//

import UIKit
import Foundation

struct UserData: Codable {
    let username, email, university: String
}

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var universityLabel: UILabel!
    
    var userInfo : [UserData] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showUserInfo()
        // Do any additional setup after loading the view.
    }
    
    func showUserInfo() {
        // get data from local files
        print("getting user data from local files")
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pathWithFilename = documentDirectory.appendingPathComponent("userInfo.json")
            do {
                let data = try Data(contentsOf: pathWithFilename)
                let info = try JSONDecoder().decode(UserData.self, from: data)
                self.userInfo = [info]
            } catch {
                print("There was an error getting user data from the local file: \(error)")
            }
        }
        
        print("self.userInfo: \(self.userInfo)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
