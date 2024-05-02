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
        self.addSubviews(self.iconImageView, self.descriptionLabel)
    }

    override func setupLayout() {
        self.iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(self.iconImageView.snp.height)
        }

        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(self.iconImageView.snp.trailing)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    override func setupProperties() {

    }

}

