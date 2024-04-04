//
//  SearchViewController.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit
import SnapKit
import Then

final class SearchViewController: BaseUIViewController {

    private lazy var mainLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        mainLabel.text = "SearchViewController"
        self.view.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}
