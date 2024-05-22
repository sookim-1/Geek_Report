//
//  UIStackView+Extension.swift
//  GeekReport
//
//  Created by sookim on 4/5/24.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach { addArrangedSubview($0) }
    }

}

