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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ExploreVC = self.tabBarController?.children[2].children[0] as! ExploreViewController

        // Do any additional setup after loading the view.
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
