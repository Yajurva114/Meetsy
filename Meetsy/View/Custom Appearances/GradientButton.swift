//
//  GradientButton.swift
//  Meetsy
//
//  Created by APPLE on 08/10/22.
//

import UIKit


import UIKit
class ActualGradientButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.frame = self.bounds
        let color1 = UIColor(red: 0.08, green: 0.72, blue: 0.65, alpha: 1.00).cgColor
        let color2 = UIColor(red: 0.23, green: 0.51, blue: 0.96, alpha: 1.00).cgColor
        l.colors = [color2, color1]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = self.frame.height / 2
        layer.insertSublayer(l, at: 0)
        return l
    }()
}
