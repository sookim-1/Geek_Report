//
//  SearchListCell.swift
//  GeekReport
//
//  Created by sookim on 5/7/24.
//

import UIKit
import SnapKit
import Then

final class SearchListCell: UICollectionViewCell, UIConfigurable {
    
    lazy var imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    lazy var labelStackView = UIStackView(arrangedSubviews: [titleLabel, episodeLabel]).then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.distribution = .equalSpacing
    }
    
    lazy var titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.numberOfLines = 2
        $0.textColor = .white
    }
    
    lazy var episodeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.numberOfLines = 1
        $0.textColor = .systemGray
    }
    
    
    lazy var arrowImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = .white
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
        self.contentView.addSubviews(imageView, labelStackView, arrowImageView)
    }
    
    func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.width.equalTo(150)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-10)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(25)
            make.height.equalTo(25)
            make.trailing.equalToSuperview()
        }
    }
    
    func setupProperties() {
        
    }
    
    
}
