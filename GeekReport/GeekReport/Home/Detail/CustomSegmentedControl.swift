//
//  CustomSegmentedControl.swift
//  GeekReport
//
//  Created by sookim on 4/26/24.
//

import UIKit
import SnapKit
import Then

struct CustomSegmentedControlProperty {
    var currentIndex: Int = 0
    var currentIndexTitleColor: UIColor = .white
    var currentIndexBackgroundColor: UIColor = .systemTeal
    var otherIndexTitleColor: UIColor = .gray
    var cornerRadius: CGFloat = 15
    var buttonCornerRadius: CGFloat = 10
    var borderColor: UIColor = .systemTeal
    var borderWidth: CGFloat = 1
    var segmentsTitleLists: [String]

    var numberOfSegments: Int {
        return segmentsTitleLists.count
    }
}

class CustomSegmentedControl: UIView, UIConfigurable {

    var stackView: UIStackView = UIStackView().then {
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 0
    }

    var buttonsCollection: [UIButton] = []
    var currentIndexView: UIView = UIView(frame: .zero)

    var buttonPadding: CGFloat = 5

    var didTapSegment: ((Int) -> Void)?

    var property: CustomSegmentedControlProperty!

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(property: CustomSegmentedControlProperty) {
        self.init(frame: .zero)

        self.property = property
        configureCustomProperty()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setCurrentIndex()
    }

    private func commonInit() {
        backgroundColor = .clear

        setupHierarchy()
        setupLayout()
        setupProperties()
    }

    func setupHierarchy() {
        self.addSubviews(self.currentIndexView, self.stackView)
        self.sendSubviewToBack(self.currentIndexView)
    }

    func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(buttonPadding)
            make.leading.equalToSuperview().offset(buttonPadding)
            make.trailing.equalToSuperview().offset(-buttonPadding)
            make.bottom.equalToSuperview().offset(-buttonPadding)
        }
    }

    func setupProperties() {
    }

    private func configureCustomProperty() {
        currentIndexView.backgroundColor = property.currentIndexBackgroundColor

        addSegments()
        updateTextColors()
        setCurrentIndex(animated: false)
        setButtonCornerRadius()

        layer.cornerRadius = property.cornerRadius
        layer.borderColor = property.borderColor.cgColor
        layer.borderWidth = property.borderWidth
    }

    private func addSegments() {
        buttonsCollection.removeAll()
        stackView.subviews.forEach { view in
            (view as? UIButton)?.removeFromSuperview()
        }

        for i in 0..<property.numberOfSegments {
            let item = property.segmentsTitleLists[i]
            let button = UIButton()
            button.tag = i
            button.setTitle(item, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16)
            button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttonsCollection.append(button)
        }
    }

    private func setCurrentIndex(animated: Bool = true) {
        stackView.subviews.enumerated().forEach { (index, view) in
            let button: UIButton? = view as? UIButton

            if index == property.currentIndex {
                let buttonWidth = (frame.width - (buttonPadding * 2)) / CGFloat(property.numberOfSegments)

                if animated {
                    UIView.animate(withDuration: 0.3) {
                        self.currentIndexView.frame =
                            CGRect(x: self.buttonPadding + (buttonWidth * CGFloat(index)),
                               y: self.buttonPadding,
                               width: buttonWidth,
                               height: self.frame.height - (self.buttonPadding * 2))
                    }
                } else {
                    self.currentIndexView.frame =
                        CGRect(x: self.buttonPadding + (buttonWidth * CGFloat(index)),
                           y: self.buttonPadding,
                           width: buttonWidth,
                           height: self.frame.height - (self.buttonPadding * 2))
                }

                button?.setTitleColor(property.currentIndexTitleColor, for: .normal)
            } else {
                button?.setTitleColor(property.otherIndexTitleColor, for: .normal)
            }
        }
    }

    private func updateTextColors() {
        stackView.subviews.enumerated().forEach { (index, view) in
            let button: UIButton? = view as? UIButton

            if index == property.currentIndex {
                button?.setTitleColor(property.currentIndexTitleColor, for: .normal)
            } else {
                button?.setTitleColor(property.otherIndexTitleColor, for: .normal)
            }
        }
    }

    private func updateSegmentTitles() {
        stackView.subviews.enumerated().forEach { (index, view) in
            let item = property.segmentsTitleLists[index]

            if let subviewButton = view as? UIButton {
                subviewButton.setTitle(item, for: .normal)
            }
        }
    }

    private func setButtonCornerRadius() {
        stackView.subviews.forEach { view in
            (view as? UIButton)?.layer.cornerRadius = property.cornerRadius
        }

        currentIndexView.layer.cornerRadius = property.cornerRadius
    }

    @objc func segmentTapped(_ sender: UIButton) {
        didTapSegment?(sender.tag)
        property.currentIndex = sender.tag
        setCurrentIndex()
    }

}

