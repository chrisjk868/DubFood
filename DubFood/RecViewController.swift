//
//  RecViewController.swift
//  DubFood
//
//  Created by Christopher Ku on 5/27/22.
//

import UIKit

class RecViewController: UIViewController {
    
    public var categories : [String]? = []
    
    let ExploreVC = ExploreViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  
    @IBAction func buttonOnClick(_ sender: UIButton) {
        print("hello world")
        print((sender.titleLabel?.text!)!)
        categories?.append("\((sender.titleLabel?.text!)!)")
        updateFilters()
        ExploreVC.printFilters()

    }
    
    func updateFilters() {
        ExploreVC.filters = categories!
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
