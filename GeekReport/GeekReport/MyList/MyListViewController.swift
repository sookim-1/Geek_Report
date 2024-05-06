//
//  MyListViewController.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit
import SnapKit
import Then

final class MyListViewController: BaseUIViewController {

    private lazy var mainLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setupProperties()
    }

    override func setupHierarchy() {
        self.view.addSubview(mainLabel)
    }

    override func setupLayout() {
        mainLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    override func setupProperties() {
        mainLabel.text = "MyListViewController"
    }

}
