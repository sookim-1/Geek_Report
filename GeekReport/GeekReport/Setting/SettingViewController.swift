//
//  SettingViewController.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit
import SnapKit
import Then

final class SettingViewController: BaseUIViewController {
    
    private lazy var mainLabel = UILabel().then {
        $0.textColor = .white
    }
    
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
        mainLabel.text = "😅 추후 계정을 이용한 서비스 준비 중 입니다"
    }
    
}
