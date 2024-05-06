//
//  DefaultBackButton.swift
//  GeekReport
//
//  Created by sookim on 5/2/24.
//

import UIKit

final class DefaultBackButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setBackgroundImage(UIImage(systemName: "arrow.backward.circle"), for: .normal)
        self.tintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
