//
//  UITabBarController+Extension.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit

extension UITabBarController {

    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        let tabBarHeight: CGFloat = tabBar.frame.size.height
        let tabBarPositionY: CGFloat = UIScreen.main.bounds.height - (hidden ? 0 : tabBarHeight)

        guard animated else {
            tabBar.frame.origin.y = tabBarPositionY
            return
        }

        UIView.animate(withDuration: duration) {
            self.tabBar.frame.origin.y = tabBarPositionY
        }
    }

}

