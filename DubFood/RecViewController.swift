//
//  RecViewController.swift
//  DubFood
//
//  Created by Christopher Ku on 5/27/22.
//

import UIKit

class RecViewController: UIViewController {
    
    public var categories : [String]? = []
    var ExploreVC: ExploreViewController?
    
    @IBOutlet weak var radiusSlider: UISlider!
    
    @IBOutlet weak var radiusLabel: UILabel!
    
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
        
        self.ExploreVC = self.tabBarController?.children[2].children[0] as! ExploreViewController

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
       AppUtility.lockOrientation(.portrait)
       // Or to rotate and lock
       // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
       
   }
    
    @IBAction func radiusSliderChanged(_ sender: UISlider) {
        var curr = Int(sender.value)
        print("Slider value: \(curr)")
        DispatchQueue.main.async {
            self.radiusLabel.text = "Radius(\(curr) miles)"
        }
        ExploreVC!.radiusVal = String(curr * 1600)
    }
    
    @IBAction func buttonOnClick(_ sender: UIButton) {
        print((sender.titleLabel?.text!)!)
        var category = (sender.titleLabel?.text!)!
        category = category.lowercased()
        if category == "fast food" {
            category = "hotdogs"
        } else if category == "indian" {
            category = "indpak"
        } else if category == "gluten-free" {
            category = "gluten_free"
        }
        if let index = categories?.firstIndex(of: category) {
            categories?.remove(at: index)
            sender.backgroundColor = UIColor.systemGray5
        } else {
            categories?.append(category)
            sender.backgroundColor = UIColor.systemGray2
        }
        ExploreVC!.filters = categories!
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
