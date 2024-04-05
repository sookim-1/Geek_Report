//
//  CustomItemView.swift
//  GeekReport
//
//  Created by sookim on 4/5/24.
//

import UIKit
import SnapKit
import Then

final class CustomItemView: BaseUIView {

    private lazy var containerView = UIView()

    private lazy var nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 11, weight: .semibold)
        $0.text = item.name
        $0.textColor = .white.withAlphaComponent(0.4)
        $0.textAlignment = .center
    }

    private lazy var iconImageView = UIImageView().then {
        $0.image = isSelected ? item.selectedIcon : item.icon
    }

    private lazy var underlineView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 2
    }

    let index: Int

    var isSelected = false {
        didSet {
            animateItems()
        }
    }

    private let item: CustomTabItem

    init(with item: CustomTabItem, index: Int) {
        self.item = item
        self.index = index

        super.init(frame: .zero)

        setupHierarchy()
        setupLayout()
        setupProperties()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupHierarchy() {
        self.addSubview(containerView)

        self.containerView.addSubviews(nameLabel, iconImageView, underlineView)
    }

    override func setupLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.center.equalToSuperview()
        }

        iconImageView.snp.makeConstraints {
            $0.height.width.equalTo(40)
            $0.top.equalToSuperview()
            $0.bottom.equalTo(nameLabel.snp.top)
            $0.centerX.equalToSuperview()
        }

        nameLabel.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(16)
        }

        underlineView.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(4)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(nameLabel.snp.centerY)
        }
    }

    override func setupProperties() {
        self.clipsToBounds = true
    }

    private func animateItems() {
        UIView.animate(withDuration: 0.4) { [unowned self] in
            self.nameLabel.alpha = self.isSelected ? 0.0 : 1.0
            self.underlineView.alpha = self.isSelected ? 1.0 : 0.0
        }
        UIView.transition(with: iconImageView,
                          duration: 0.4,
                          options: .transitionCrossDissolve) { [unowned self] in
            self.iconImageView.image = self.isSelected ? self.item.selectedIcon : self.item.icon
        }
    }

}
