//
//  SimpleIconLabelView.swift
//  GeekReport
//
//  Created by sookim on 4/26/24.
//

import UIKit
import SnapKit
import Then

final class SimpleIconLabelView: BaseUIView {
    
    lazy var iconImageWrapView = UIView().then {
        $0.addSubview(self.iconImageView)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .systemBrown
    }
    
    lazy var iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    lazy var labelStackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel]).then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 2
    }
    
    lazy var titleLabel = UILabel().then {
        $0.textColor = .systemGray2
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 1
    }

    lazy var descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 19)
        $0.textColor = .black
        $0.numberOfLines = 1
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

    convenience init(image: UIImage?, title: String, description: String) {
        self.init(frame: .zero)

        self.iconImageView.image = image
        self.titleLabel.text = title
        self.descriptionLabel.text = description
    }

    override func setupHierarchy() {
        self.addSubviews(self.iconImageWrapView, self.labelStackView)
    }

    override func setupLayout() {
        self.iconImageWrapView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(labelStackView.snp.leading).offset(-5)
            make.top.equalToSuperview()
            make.height.equalTo(self.iconImageWrapView.snp.width)
            make.bottom.equalToSuperview()
        }
        
        self.iconImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.center.equalToSuperview()
        }
        
        self.labelStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    override func setupProperties() {

    }

}

