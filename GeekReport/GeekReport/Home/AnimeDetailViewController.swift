//
//  AnimeDetailViewController.swift
//  GeekReport
//
//  Created by sookim on 4/26/24.
//

import UIKit
import SnapKit
import Then

final class AnimeDetailViewController: BaseUIViewController {

    // MARK: - Header View
    lazy var mainHeaderView = UIView()

    lazy var animeImagView = UIImageView().then {
        $0.backgroundColor = .systemBlue
    }

    lazy var animeTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.text = "나의 히어로 아카데미아아아아"
    }

    lazy var scoreIconLabelView = SimpleIconLabelView(image: UIImage(systemName: "star.fill"), text: "8.5")
    lazy var heartIconLabelView = SimpleIconLabelView(image: UIImage(systemName: "heart.fill"), text: "8K")
    lazy var saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)

        $0.setTitleColor(.darkGray, for: .disabled)
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundColor(.lightGray, for: .disabled)
        $0.setBackgroundColor(.purple.withAlphaComponent(0.8), for: .normal)
        $0.layer.cornerRadius = 16
    }

    let customSegmentedControlProperty = CustomSegmentedControlProperty(currentIndex: 0, segmentsTitleLists: ["에피소드", "상세내용", "옵션"])
    lazy var chapterSegmentedControl = CustomSegmentedControl(property: self.customSegmentedControlProperty)

    lazy var detailContainerView = UIView().then {
        $0.backgroundColor = .systemMint
    }
    
    private var chapterVC: ChapterViewController = ChapterViewController()
    private var shortAnimeDetailVC: ShortAnimeDetailViewController = ShortAnimeDetailViewController()
    private var optionVC: OptionViewController = OptionViewController()

    var item: AnimeData!

    init(item: AnimeData) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setupProperties()
        updateView(index: 0)

        self.chapterSegmentedControl.didTapSegment = { index in
            self.updateView(index: index)
        }
    }

    override func setupHierarchy() {
        self.view.addSubviews(mainHeaderView, chapterSegmentedControl, detailContainerView)

        self.mainHeaderView.addSubviews(animeImagView, animeTitleLabel, scoreIconLabelView, heartIconLabelView, saveButton)

        addChild(chapterVC)
        addChild(shortAnimeDetailVC)
        addChild(optionVC)

        self.detailContainerView.addSubviews(chapterVC.view, shortAnimeDetailVC.view, optionVC.view)

        chapterVC.didMove(toParent: self)
        shortAnimeDetailVC.didMove(toParent: self)
        optionVC.didMove(toParent: self)
    }

    override func setupLayout() {
        self.mainHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.chapterSegmentedControl.snp.top)
            make.height.equalToSuperview().multipliedBy(0.3)
        }

        self.animeImagView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(self.mainHeaderView.snp.centerX).offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }

        self.animeTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(self.mainHeaderView.snp.centerX).offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        self.scoreIconLabelView.snp.makeConstraints { make in
            make.top.equalTo(self.animeTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(self.animeTitleLabel.snp.leading)
            make.trailing.equalTo(self.animeTitleLabel.snp.trailing)
            make.height.equalToSuperview().multipliedBy(0.15)
        }

        self.heartIconLabelView.snp.makeConstraints { make in
            make.top.equalTo(self.scoreIconLabelView.snp.bottom).offset(8)
            make.leading.equalTo(self.animeTitleLabel.snp.leading)
            make.trailing.equalTo(self.animeTitleLabel.snp.trailing)
            make.height.equalToSuperview().multipliedBy(0.15)
        }

        self.saveButton.snp.makeConstraints { make in
            make.top.equalTo(self.heartIconLabelView.snp.bottom).offset(8)
            make.leading.equalTo(self.animeTitleLabel.snp.leading)
            make.trailing.equalTo(self.animeTitleLabel.snp.trailing)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalToSuperview().multipliedBy(0.3)
        }

        self.chapterSegmentedControl.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
        }

        self.detailContainerView.snp.makeConstraints { make in
            make.top.equalTo(self.chapterSegmentedControl.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-(GlobalConstant.customTabBarHeight + 10))
        }

        self.chapterVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.shortAnimeDetailVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.optionVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func setupProperties() {
        
    }

    private func updateView(index: Int) {
        chapterVC.view.isHidden = index != 0
        shortAnimeDetailVC.view.isHidden = index != 1
        optionVC.view.isHidden = index != 2
    }
}
