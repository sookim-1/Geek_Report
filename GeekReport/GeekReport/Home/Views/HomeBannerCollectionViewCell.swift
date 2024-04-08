//
//  HomeBannerCollectionViewCell.swift
//  GeekReport
//
//  Created by sookim on 4/8/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class HomeBannerCollectionViewCell: UICollectionViewCell, UIConfigurable {

    static let reuseID = String(describing: HomeBannerCollectionViewCell.self)

    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    private lazy var titleLabel = UILabel().then {
        $0.textAlignment = .left
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)

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
            make.height.equalTo(0)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setupProperties() {

    }
    
    func configureUI(imageURL: String, title: String) {
        self.imageView.kf.setImage(with: URL(string: imageURL)!) { result in
            switch result {
            case .success(let value):
                // 이미지 사이즈맞도록 리사이징
                let newImage = value.image.resizeImageWithRenderer(newWidth: DeviceUI.shared.screenSize.width)

                self.imageView.snp.updateConstraints { make in
                    make.height.equalTo(newImage.size.height)
                }

                self.imageView.image = newImage
            case .failure(let error):
                print("\(error)")
            }
        }
        self.titleLabel.text = title
    }
}
