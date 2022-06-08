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
    
    var userSettingsVC : UserProfileViewController?
    
    struct AppUtility {

        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }

        /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
       
            self.lockOrientation(orientation)
        
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userSettingsVC = (self.tabBarController?.children[3].children[0] as! UserProfileViewController)
        
        getUserInfo()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppUtility.lockOrientation(.portrait)
        
    }
    
    @IBAction func ChangeProfileSettingsBtn(_ sender: Any) {
        // instantiate the change profile settings vc
        
        let changeSettingsVC = storyboard?.instantiateViewController(identifier: "ChangeProfileSettingsVC") as! ChangeUserProfileSettingsViewController
        //let changeSettingsVC = ChangeUserProfileSettingsViewController()
        self.navigationController?.pushViewController(changeSettingsVC, animated: true)
        
    }
    
    func getUserInfo() {
        // get data from local files
        print("getting user data from local files")
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pathWithFilename = documentDirectory.appendingPathComponent("userInfo.json")
            do {
                let data = try Data(contentsOf: pathWithFilename)
                let info = try JSONDecoder().decode(UserData.self, from: data)
                self.userInfo = [info]
                showUserInfo()
            } catch {
                print("There was an error getting user data from the local file: \(error)")
            }
        }
        
        //print("self.userInfo: \(self.userInfo)")
    }
    
    func showUserInfo() {
        // TODO: NEED TO ATTACH TO STORYBOARD ELEMENTS
        let name = self.userInfo[0].username
        let email = self.userInfo[0].email
        let uni = self.userInfo[0].university
        usernameLabel.text = "\(name)"
        emailLabel.text = "\(email)"
        universityLabel.text = "\(uni)"
        
//        switch name {
//        case "Amaya":
//            self.profileImage.image = resizeImage(image: UIImage(named: "Amaya")!, targetSize: CGSize(width: CGFloat(120), height: CGFloat(120)))
//            self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
//        case "Chris":
//            self.profileImage.image = resizeImage(image: UIImage(named: "Chris")!, targetSize: CGSize(width: CGFloat(120), height: CGFloat(120)))
//            self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
//        case "Matt":
//            self.profileImage.image = resizeImage(image: UIImage(named: "Matt")!, targetSize: CGSize(width: CGFloat(120), height: CGFloat(120)))
//            self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
//        case "Max":
//            self.profileImage.image = resizeImage(image: UIImage(named: "Max")!, targetSize: CGSize(width: CGFloat(120), height: CGFloat(120)))
//            self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
//        default:
//            return
//        }
        
        self.profileImage.clipsToBounds = true
        
        print("\(name), \(email), \(uni)")
    }
    
//    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
//        let size = image.size
//
//        let widthRatio  = targetSize.width  / image.size.width
//        let heightRatio = targetSize.height / image.size.height
//
//        // Figure out what our orientation is, and use that to form the rectangle
//        var newSize: CGSize
//        if(widthRatio > heightRatio) {
//            newSize = CGSize(width: targetSize.width, height: size.height * heightRatio)
//        } else {
//            newSize = CGSize(width: targetSize.width,  height: size.height * widthRatio)
//        }
//
//        // This is the rect that we've calculated out and this is what is actually used below
//        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
//
//        // Actually do the resizing to the rect using the ImageContext stuff
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//        image.draw(in: rect)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage!
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
