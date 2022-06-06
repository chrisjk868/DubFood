//
//  TabBarViewController.swift
//  DubFood
//
//  Created by Christopher Ku on 6/5/22.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        for item in self.view.subviews {
            item.clipsToBounds = false
        }
        self.view.clipsToBounds = false
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            (viewController as? UINavigationController)?.popToRootViewController(animated: true)
            return true
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
