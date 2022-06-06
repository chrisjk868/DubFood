//
//  OnBoardingViewController.swift
//  DubFood
//
//  Created by Christopher Ku on 5/27/22.
//

import UIKit
import CoreLocation

class OnBoardingViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var university: UIPickerView!
    @IBOutlet weak var submit: UIButton!

    var lat : Double = 47.655548
    var long : Double = -122.303200

    var pickerData : [String] = ["University of Washington", "Seattle University", "Washington State"]

    var selectedUniversity = "University of Washington"


    override func viewDidLoad() {
        super.viewDidLoad()

        university.delegate = self
        university.dataSource = self

        // Do any additional setup after loading the view.

        // Get User Location

        //HOW TO INITIATE THE DATABASE
        // let database = FirebaseInterface()

        let location = CLLocationManager()
        location.delegate = self

        location.requestWhenInUseAuthorization()

        // Get the current location permissions

        DispatchQueue.global(qos: .userInitiated).async {
            // Handle each case of location permissions
            while true {
                let status = location.authorizationStatus
                switch status {
                    case .authorizedAlways:
                        location.requestLocation()
                        print("location always authorized")
                    case .authorizedWhenInUse:
                        location.requestLocation()
                        print("location authorized in use")
                    case .denied:
                        print("location denied. Using default coordinates")
                    case .notDetermined:
                        print("location undetermined")
                    case .restricted:
                        print("location denied. Using default coordinates")
                    default:
                        return
                }
                if status == .authorizedAlways || status == .authorizedWhenInUse {
                    print("================broken==================")
                    break
                }
            }
        }

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            self.lat = lat
            self.long = long
            print("\(self.lat), \(self.long)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Request Failed")
    }

    @IBAction func submitBtnClick(_ sender: Any) {
        checkValues()
    }
    
    // a function that ensures that all onboarding items have a value entered by the user
    // if all values exist: continues
    // if no value: shows an alert
    func checkValues() {
        var complete = true
        
        // checking the username & email to make sure they are not blank
        if self.username.text ?? "" == "" {
            complete = false
        } else if self.email.text ?? "" == "" {
            complete = false
        }
        
        // if complete is true, save user data
        if complete {
            saveUserDataLocally()
            
            // instantiate the new view controller
            let tabBarVC = storyboard?.instantiateViewController(identifier: "TabBarVC") as! TabBarViewController
            tabBarVC.modalPresentationStyle = .fullScreen
            present(tabBarVC, animated: true)

            
            
        } else { // make an alert!!
            let alert = UIAlertController(title: "Error", message: "Please make sure that you have filled in all required fields.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK",
                                                              style: .default,
                                                              handler: { _ in NSLog("\"OK\" pressed.")

                                }))
                                self.present(alert, animated: true, completion: {
                                  NSLog("The completion handler fired")
                                })
        }
        
    }

    func saveUserDataLocally() {
//        print("SELECTED UNIVERSITY: \(self.selectedUniversity)")
//        print("USERNAME: \(self.username.text ?? "")")
//        print("EMAIL: \(self.email.text ?? "")")

        // format the user data into a json
        let userInfo = "{\"username\":\"\(self.username.text ?? "")\", \"email\":\"\(self.email.text ?? "")\", \"university\":\"\(self.selectedUniversity)\"}"

        // save the user information to a local file (NEED TO FIX)
        do {
            // save to a local file
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let pathWithFilename = documentDirectory.appendingPathComponent("userInfo.json")
                do {
                    try userInfo.write(to: pathWithFilename, atomically: true, encoding: .utf8)
                } catch {
                    print("There was an error writing to a local file: \(error)")
                }
            }
        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        let on_board_vc = segue.destination as! ViewController
//        on_board_vc.location = (self.lat, self.long)
//    }

}

extension OnBoardingViewController : UIPickerViewDelegate {

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //print("SELECTED ROW: \(row)")
        self.selectedUniversity = pickerData[row]
        return pickerData[row]
    }

}

extension OnBoardingViewController : UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //print("COUNT: \(pickerData.count)")
        return pickerData.count
    }
}
