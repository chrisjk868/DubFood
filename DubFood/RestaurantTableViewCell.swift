//
//  RestaurantTableViewCell.swift
//  DubFood
//
//  Created by Christopher Ku on 6/5/22.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurantView: UIView!
    @IBOutlet weak var restaurantImg: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var restaurantLoc: UILabel!
    @IBOutlet weak var restaurantPriceLvl: UIStackView!
    @IBOutlet weak var firstDollar: UIImageView!
    
    let dollar : UIImage = UIImage(systemName: "dollarsign.circle")!
    var launched = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        restaurantView.layer.cornerRadius = restaurantView.frame.height / 3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updatePriceLvl(priceLvl : Int) {
        print("========================================================")
        print("price lvl: \(priceLvl)")
        if self.restaurantPriceLvl.arrangedSubviews.count > 0 {
            for item in self.restaurantPriceLvl.arrangedSubviews {
                self.restaurantPriceLvl.removeArrangedSubview(item)
            }
        }
        for stackIndex in 0...(priceLvl - 1) {
            let dollarView = UIImageView(image: self.dollar)
            if priceLvl < 2 {
                firstDollar.tintColor = .systemGreen
                dollarView.tintColor = .systemGreen
            } else if priceLvl >= 2 && priceLvl < 3 {
                firstDollar.tintColor = .systemYellow
                dollarView.tintColor = .systemYellow
            } else {
                firstDollar.tintColor = .systemRed
                dollarView.tintColor = .systemRed
            }
            dollarView.frame = CGRect(x: 0, y: 0, width: 20, height: 19)
            self.restaurantPriceLvl.addArrangedSubview(dollarView)
        }
        print("items: \(self.restaurantPriceLvl.arrangedSubviews.count)")
        print("========================================================")
    }

}
