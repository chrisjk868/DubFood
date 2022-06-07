//
//  ChangeUserProfileSettingsViewController.swift
//  DubFood
//
//  Created by Amaya Kejriwal on 6/6/22.
//

import UIKit

class ChangeUserProfileSettingsViewController: UIViewController {

    @IBOutlet weak var newUsernameTextField: UITextField!
    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var newUniversityPicker: UIPickerView!
    
    var userInfo : [UserData] = []
    
    var username : String = ""
    var email : String = ""
    var university : String = ""
    
    var pickerData : [String] = ["University of Washington", "Seattle University", "Washington State"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        newUniversityPicker.delegate = self
        newUniversityPicker.dataSource = self
        
        // get old user profile info
        getOldUserInfo()
        
        // Do any additional setup after loading the view.
    }
    
    func getOldUserInfo() {
        // get data from local files
        print("getting user data from local files")
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pathWithFilename = documentDirectory.appendingPathComponent("userInfo.json")
            do {
                let data = try Data(contentsOf: pathWithFilename)
                let info = try JSONDecoder().decode(UserData.self, from: data)
                
                self.userInfo = [info]
                
                self.username = self.userInfo[0].username
                self.email = self.userInfo[0].email
                self.university = self.userInfo[0].university
                
                populateDefaultValues()
                
            } catch {
                print("There was an error getting user data from the local file: \(error)")
            }
        }
    }
        
    func populateDefaultValues() {
        let usernamePlaceholder = NSAttributedString(string: self.username, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        let emailPlaceholder = NSAttributedString(string: self.email, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        
        // check which row should be selected
        var row = 0
        for uni in pickerData {
            if uni == self.university {
                newUniversityPicker.selectRow(row, inComponent: 0, animated: true)
            }
            row += 1
        }

        
        newUsernameTextField.attributedPlaceholder = usernamePlaceholder
        newEmailTextField.attributedPlaceholder = emailPlaceholder
        //newUniversityPicker.selectRow(2, inComponent: 0, animated: true)
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        // see if any of the values need to be changed
        if newUsernameTextField.text != "" {
            self.username = newUsernameTextField.text!
        }
        
        if newEmailTextField.text != "" {
            self.email = newEmailTextField.text!
        }
        
        // save data method
        saveUserDataLocally()
    }
    
    func saveUserDataLocally() {
        // format the user data into a json
        let userInfo = "{\"username\":\"\(self.username)\", \"email\":\"\(self.email)\", \"university\":\"\(self.university)\"}"

        // save the user information to a local file (NEED TO FIX)
        do {
            // save to a local file -- override the current file!!
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let pathWithFilename = documentDirectory.appendingPathComponent("userInfo.json")
                do {
                    try userInfo.write(to: pathWithFilename, atomically: true, encoding: .utf8)
                    
                    // get rid of the view controller
                    if let navController = self.navigationController, navController.viewControllers.count >= 2 {
                        let viewController = navController.viewControllers[navController.viewControllers.count - 2] as! UserProfileViewController
                        viewController.getUserInfo()
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                    // self.dismiss(animated: true, completion: nil)
                    // reload the userProfileViewController
                } catch {
                    print("There was an error writing to a local file: \(error)")
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

            if let firstVC = presentingViewController as? UserProfileViewController {
                DispatchQueue.main.async {
                    firstVC.viewDidLoad()
                }
            }
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

extension ChangeUserProfileSettingsViewController : UIPickerViewDelegate {

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //print("SELECTED ROW: \(row)")
        self.university = pickerData[row]
        return pickerData[row]
    }

}

extension ChangeUserProfileSettingsViewController : UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //print("COUNT: \(pickerData.count)")
        return pickerData.count
    }
}
