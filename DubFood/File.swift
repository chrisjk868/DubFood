//
//  File.swift
//  DubFood
//
//  Created by Christopher Ku on 6/6/22.
//

import Foundation

class ManualSegue: UIStoryboardSegue {

  override func perform() {
    sourceViewController.presentViewController(destinationViewController, animated: true) {
      self.sourceViewController.navigationController?.popToRootViewControllerAnimated(false)
      UIApplication.sharedApplication().delegate?.window??.rootViewController = self.destinationViewController
    }
  }
}
