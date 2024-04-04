//
//  HomeNavigationViewController.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit

final class HomeNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        self.tabBarItem.title = "홈"
        self.tabBarItem.image = UIImage(systemName: "house")
    }

}
