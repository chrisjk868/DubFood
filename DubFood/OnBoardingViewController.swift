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
        university.delegate = self
        university.dataSource = self
        
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
        
        // checking if the user has already been onboarded (has a local file saved)
        var userExists = false
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("userInfo.json") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("LOCAL FILE AVAILABLE")
                userExists = true
            } else {
                print("LOCAL FILE NOT AVAILABLE")
            }
        } else {
            print("FILE PATH NOT AVAILABLE")
        }
        
        
        
        if userExists {
            // present the storyboard
            let tabBarVC = storyboard?.instantiateViewController(identifier: "TabBarVC") as! TabBarViewController
            tabBarVC.modalPresentationStyle = .fullScreen
            present(tabBarVC, animated: false)
        }
        

        // Get User Location

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
                if status == .authorizedAlways || status == .authorizedWhenInUse || status == .denied{
                    print("================broken==================")
                    if status == .denied {
                        self.lat = 47.655548
                        self.long = -122.303200
                    }
                    break
                }
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
       AppUtility.lockOrientation(.portrait)
       // Or to rotate and lock
       // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
       
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

    //Items in picker view
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedUniversity = pickerData[row]
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
