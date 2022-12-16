//
//  UIView + Extensions.swift
//  SortingAnimator
//
//  Created by Robert Miller on 16.12.2022.
//

import UIKit

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-5.0, 5.0, -5.0, 5.0, -5.0, 5.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }

    func addSubviewsWithMask(_ subviews: [UIView]) {
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
}
