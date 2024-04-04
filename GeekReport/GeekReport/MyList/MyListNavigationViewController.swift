//
//  MyListNavigationViewController.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit

final class MyListNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarItem.selectedImage = UIImage(systemName: "list.bullet.rectangle.fill")
        self.tabBarItem.title = "나의 목록"
        self.tabBarItem.image = UIImage(systemName: "list.bullet.rectangle")
    }


}
