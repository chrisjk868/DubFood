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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Get User Location
        
        //HOW TO INITIATE THE DATABASE
        let database = FirebaseInterface()
        
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
