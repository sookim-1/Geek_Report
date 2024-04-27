//
//  AnimeCollectionViewCell.swift
//  GeekReport
//
//  Created by sookim on 4/16/24.
//

import UIKit
import SnapKit
import Then

final class AnimeCollectionViewCell: UICollectionViewCell, UIConfigurable {
    
    lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
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
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
    
    func setupProperties() {
        
    }
    
    
}
