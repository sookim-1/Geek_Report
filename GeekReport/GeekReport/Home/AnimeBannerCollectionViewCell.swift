//
//  AnimeBannerCollectionViewCell.swift
//  GeekReport
//
//  Created by sookim on 4/28/24.
//

import UIKit
import SnapKit
import Then

final class AnimeBannerCollectionViewCell: UICollectionViewCell, UIConfigurable {
    
    lazy var mainWrapView = UIView()
    
    lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 26, weight: .bold)
        $0.numberOfLines = 0
        $0.textColor = .white
    }
    
    lazy var imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
        setupProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupHierarchy() {
        self.contentView.addSubviews(imageView, titleLabel)
    }
    
    func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.leading).offset(20)
            make.trailing.equalTo(imageView.snp.trailing).offset(-20)
            make.bottom.equalTo(imageView.snp.bottom).offset(-20)
        }
    }
    
    func setupProperties() {
        
    }
    
    
}
