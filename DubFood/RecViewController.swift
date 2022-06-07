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
    
    @IBOutlet weak var updateBtn: UIButton!
    //let ExploreVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "exploreRest") as! ExploreViewController
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ExploreVC = self.tabBarController?.children[2].children[0] as! ExploreViewController
        if ((categories?.isEmpty) != nil) {
            updateBtn.isEnabled = false
        } else {
            updateBtn.isEnabled = true
        }

        // Do any additional setup after loading the view.
    }
    
  
    @IBAction func buttonOnClick(_ sender: UIButton) {
        print("hello world")
        print((sender.titleLabel?.text!)!)
        if let index = categories?.firstIndex(of: (sender.titleLabel?.text!)!) {
            categories?.remove(at: index)
            if ((categories?.isEmpty) != nil) {
                updateBtn.isEnabled = false
            } else {
                updateBtn.isEnabled = true
            }
        } else {
            categories?.append("\((sender.titleLabel?.text!)!)")
            updateBtn.isEnabled = true
        }
        ExploreVC!.printFilters()
    }
    
    @IBAction func updateBtnClicked(_ sender: UIButton) {
        ExploreVC!.filters = categories!
        //ExploreVC.makeRequest(coordinates: ExploreVC.location)
        tabBarController?.selectedIndex = 2
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
