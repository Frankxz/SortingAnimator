//
//  CustomProgressView.swift
//  SortingAnimator
//
//  Created by Robert Miller on 16.12.2022.
//

import UIKit

class CustomProgressView: UIView {
    var color: UIColor = .gray {
        didSet { setNeedsDisplay() }
    }

    var gradientColor: UIColor = .systemGreen{
        didSet { setNeedsDisplay() }
    }

    var ringWidth: CGFloat = 5

    var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }

    private var progressLayer = CAShapeLayer()
    private var backgroundMask = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        createAnimation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
        createAnimation()
    }

    private func setupLayers() {
        backgroundMask.lineWidth = ringWidth
        backgroundMask.fillColor = nil
        backgroundMask.strokeColor = UIColor.black.cgColor
        layer.mask = backgroundMask
        backgroundColor = UIColor.black

        progressLayer.lineWidth = ringWidth
        progressLayer.fillColor = nil

        layer.addSublayer(gradientLayer)

        gradientLayer.mask = progressLayer
        gradientLayer.locations = [0.35, 0.5, 0.65]
    }

    private func createAnimation() {
        // MARK: Rotation Animation

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")

        rotationAnimation.fromValue = CGFloat(Double.pi / 2)
        rotationAnimation.toValue = CGFloat(2.5 * Double.pi)
        rotationAnimation.repeatCount = Float.infinity
        rotationAnimation.duration = 4

        gradientLayer.add(rotationAnimation, forKey: "rotationAnimation")


        // MARK: Gradient Animation
        let startPointAnimation = CAKeyframeAnimation(keyPath: "startPoint")
        startPointAnimation.values = [CGPoint.zero, CGPoint(x: 1, y: 0), CGPoint(x: 1, y: 1)]

        startPointAnimation.repeatCount = Float.infinity
        startPointAnimation.duration = 1

        let endPointAnimation = CAKeyframeAnimation(keyPath: "endPoint")
        endPointAnimation.values = [CGPoint(x: 1, y: 1), CGPoint(x: 0, y: 1), CGPoint.zero]

        endPointAnimation.repeatCount = Float.infinity
        endPointAnimation.duration = 1

        gradientLayer.add(startPointAnimation, forKey: "startPointAnimation")
        gradientLayer.add(endPointAnimation, forKey: "endPointAnimation")
    }

    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: ringWidth / 2, dy: ringWidth / 2))
        backgroundMask.path = circlePath.cgPath

        progressLayer.path = circlePath.cgPath
        progressLayer.lineCap = .round
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = progress
        progressLayer.strokeColor = UIColor.black.cgColor

        gradientLayer.frame = rect
        gradientLayer.colors = [color.cgColor, gradientColor.cgColor, color.cgColor]
    }
}

