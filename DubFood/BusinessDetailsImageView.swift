//
//  BusinessDetailsImageView.swift
//  DubFood
//
//  Created by Christopher Ku on 6/3/22.
//

import UIKit

class BusinessDetailsImageView: UIImageView {
    
    func loadImage(url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in guard let data = data, let new_img = UIImage(data: data) else {
                print("Image can't be loaded")
                return
            }
            DispatchQueue.main.async {
//                self.image = new_img.resizeImage(CGFloat(225), opaque: true)
                self.image = self.resizeImage(image: new_img, targetSize: CGSize(width: CGFloat(UIScreen.main.bounds.width), height: CGFloat(128)))
            }
        }
        task.resume()
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: targetSize.width, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: targetSize.width,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
