//
//  SearchNavigationViewController.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit

final class SearchNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")
        self.tabBarItem.title = "검색"
        self.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle")
    }

}
