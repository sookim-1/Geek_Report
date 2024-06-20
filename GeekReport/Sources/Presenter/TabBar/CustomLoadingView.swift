//
//  CustomLoadingView.swift
//  GeekReport
//
//  Created by sookim on 6/20/24.
//  Copyright © 2024 sookim-1. All rights reserved.
//

import UIKit
import Then

final class CustomLoadingView: UIView {

    enum Direction: String {
        case x, y, z
    }

    private let colors: [UIColor]
    private let lineWidth: CGFloat

    private lazy var shapeLayer = CAShapeLayer().then {
        $0.strokeColor = colors.first!.cgColor
        $0.lineWidth = lineWidth
        $0.fillColor = UIColor.clear.cgColor
        $0.lineCap = .round
    }
    private lazy var strokeStartAnimation = CABasicAnimation().then {
        $0.keyPath = "strokeStart"
        $0.beginTime = 0.25
        $0.fromValue = 0.0
        $0.toValue = 1.0
        $0.duration = 0.75
        $0.timingFunction = .init(name: .easeInEaseOut)
    }

    private lazy var strokeEndAnimation = CABasicAnimation().then {
        $0.keyPath = "strokeEnd"
        $0.beginTime = 0.0
        $0.fromValue = 0.0
        $0.toValue = 1.0
        $0.duration = 0.75
        $0.timingFunction = .init(name: .easeInEaseOut)
    }

    private lazy var strokeColorAnimation = CAKeyframeAnimation().then {
        $0.keyPath = "strokeColor"
        $0.values = colors.map { $0.cgColor }
        $0.repeatCount = .greatestFiniteMagnitude
        $0.timingFunction = .init(name: .easeInEaseOut)
    }

    private lazy var rotationAnimation = CABasicAnimation().then {
        $0.keyPath = "transform.rotation.\(Direction.z.rawValue)"
        $0.fromValue = 0
        $0.toValue = CGFloat.pi * 2
        $0.duration = 2
        $0.repeatCount = .greatestFiniteMagnitude
    }

    var isAnimating: Bool = false {
        didSet {
            if isAnimating {
                self.animateStroke()
                self.layer.add(self.rotationAnimation, forKey: nil)
            } else {
                self.shapeLayer.removeFromSuperlayer()
                self.layer.removeAllAnimations()
            }
        }
    }

    init(frame: CGRect, colors: [UIColor], lineWidth: CGFloat) {
        self.colors = colors
        self.lineWidth = lineWidth

        super.init(frame: frame)

        self.backgroundColor = .clear
    }

    convenience init(colors: [UIColor], lineWidth: CGFloat) {
        self.init(frame: .zero, colors: colors, lineWidth: lineWidth)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = self.frame.width / 2

        let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: CGSize(width: self.bounds.width, height: self.bounds.width)))

        shapeLayer.path = path.cgPath
    }

    func animateStroke() {
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1
        strokeAnimationGroup.repeatDuration = .infinity
        strokeAnimationGroup.animations = [self.strokeStartAnimation, self.strokeEndAnimation]

        shapeLayer.add(strokeAnimationGroup, forKey: nil)

        self.strokeColorAnimation.duration = strokeAnimationGroup.duration * Double(colors.count)
        shapeLayer.add(self.strokeColorAnimation, forKey: nil)

        self.layer.addSublayer(shapeLayer)
    }

}
