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
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
    }

    lazy var iconImageView = UIImageView()

    lazy var descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
        $0.textAlignment = .left
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

    convenience init(image: UIImage?, text: String) {
        self.init(frame: .zero)

        self.iconImageView.image = image
        self.descriptionLabel.text = text
    }

    override func setupHierarchy() {
        self.addSubviews(self.iconImageWrapView, self.descriptionLabel)
        self.iconImageWrapView.addSubviews(self.iconImageView)
    }

    override func setupLayout() {
        self.iconImageWrapView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.35)
            make.height.equalTo(self.iconImageWrapView.snp.width)
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }

        self.iconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.iconImageWrapView.snp.trailing)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    override func setupProperties() {

    }

}

