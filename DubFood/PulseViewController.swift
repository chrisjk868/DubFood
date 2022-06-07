//
//  PulseViewController.swift
//  DubFood
//
//  Created by Christopher Ku on 6/7/22.
//

import UIKit

class PulseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let pulsingView = PulsingView()
        pulsingView.center = CGPoint(x: self.view.frame.size.width  / 2,
                                     y: self.view.frame.size.height / 2)
        view.addSubview(pulsingView)
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
