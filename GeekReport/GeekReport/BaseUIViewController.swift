//
//  BaseUIViewController.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit

class BaseUIViewController: UIViewController, UIConfigurable {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
    }

    func setupHierarchy() {}

    func setupLayout() {}

    func setupProperties() {}

}
