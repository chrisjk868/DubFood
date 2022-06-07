//
//  PulsingView.swift
//  DubFood
//
//  Created by Christopher Ku on 6/7/22.
//

import UIKit

class PulsingView: UIView {

    init() {
            super.init(frame: .zero)
            layer.addSublayer(pulsingLayer)
            layer.addSublayer(mainLayer)
            pulsingLayer.add(animationGroup, forKey: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private lazy var animationGroup: CAAnimationGroup = {
            let animationGroup = CAAnimationGroup()
            animationGroup.animations = [expandingAnimation,
                                         fadingAnimation]
            animationGroup.duration = 1.5
            animationGroup.repeatCount = .infinity
            return animationGroup
        }()
        
        private lazy var fadingAnimation: CABasicAnimation = {
            let fadingAnimation = CABasicAnimation(keyPath: "opacity")
            fadingAnimation.fromValue = 1
            fadingAnimation.toValue = 0
            return fadingAnimation
        }()
        
        private lazy var expandingAnimation: CABasicAnimation = {
            let expandingAnimation = CABasicAnimation(keyPath: "transform.scale")
            expandingAnimation.fromValue = 1
            expandingAnimation.toValue = 1.4
            return expandingAnimation
        }()
        
        private let mainLayer: CAShapeLayer = circleLayer(color: Constant.mainColor)
        private let pulsingLayer: CAShapeLayer = circleLayer(color: Constant.pulsingColor)
        
        private static func circleLayer(color: CGColor) -> CAShapeLayer {
            let circleLayer = CAShapeLayer()
            circleLayer.path = Constant.bezierPath.cgPath
            circleLayer.lineWidth = 30
            circleLayer.strokeColor = color
            circleLayer.fillColor = UIColor.clear.cgColor
            return circleLayer
        }
        
        private enum Constant {
            static let bezierPath: UIBezierPath = .init(arcCenter: CGPoint.zero,
                                                        radius: 100,
                                                        startAngle: -(CGFloat.pi / 2),
                                                        endAngle: -(CGFloat.pi / 2) + (2 * CGFloat.pi),
                                                        clockwise: true)
            // UW purple: red: 0.2941, green: 0.1804, blue: 0.5137, alpha: 1.0
            // Gold: red: 1, green: 0.8, blue: 0, alpha: 1.0
            // Metallic Gold: red 0.5216, green: 0.4588, blue: 0.302, alpha: 1.0
            static let mainColor: CGColor = UIColor(red: 0.2941, green: 0.1804, blue: 0.5137, alpha: 1.0).cgColor
            static let pulsingColor: CGColor = UIColor(red: 0.2941, green: 0.1804, blue: 0.5137, alpha: 1.0).cgColor
        }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
