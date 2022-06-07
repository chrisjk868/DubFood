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

        // Do any additional setup after loading the view.
    }
    
  
    @IBAction func buttonOnClick(_ sender: UIButton) {
        print((sender.titleLabel?.text!)!)
        
        if let index = categories?.firstIndex(of: (sender.titleLabel?.text!)!) {
            categories?.remove(at: index)
            sender.backgroundColor = UIColor.systemGray2
        } else {
            categories?.append("\((sender.titleLabel?.text!)!)")
            sender.backgroundColor = UIColor.darkGray
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
