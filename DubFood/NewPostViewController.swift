//
//  NewPostViewController.swift
//  DubFood
//
//  Created by iguest on 6/1/22.
//

import UIKit

class NewPostViewController: UIViewController {

    @IBOutlet weak var postContentTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postContentTxtField.borderStyle = UITextField.BorderStyle.roundedRect
        // Do any additional setup after loading the view.
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
