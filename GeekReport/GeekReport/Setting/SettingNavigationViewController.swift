//
//  SettingNavigationViewController.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit

final class SettingNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarItem.selectedImage = UIImage(systemName: "gearshape.fill")
        self.tabBarItem.title = "설정"
        self.tabBarItem.image = UIImage(systemName: "gearshape")
    }

}
