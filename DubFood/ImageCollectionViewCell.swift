//
//  ImageCollectionViewCell.swift
//  DubFood
//
//  Created by Christopher Ku on 6/3/22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var business_img: BusinessDetailsImageView!
    
    func makeRounded() {
//        self.business_img.layer.cornerRadius = 10.0
        self.business_img.clipsToBounds = true
    }
    
}
