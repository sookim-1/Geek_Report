//
//  AnimeDetailViewController.swift
//  GeekReport
//
//  Created by sookim on 4/26/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import RxSwift
import RxCocoa

final class AnimeDetailViewController: BaseUIViewController {

    lazy var backButton = DefaultBackButton()
    lazy var mainScrollView = UIScrollView()
    lazy var headerImageWrapView = UIView()
    lazy var headerImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }

    lazy var mainContentView = UIView().then {
        $0.backgroundColor = .systemGray6
    }

    lazy var mainHeaderView = UIView()

    lazy var animeTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 34, weight: .heavy)
        $0.textColor = .white
        $0.numberOfLines = 2
        $0.textAlignment = .right
    }
    
    lazy var iconLabelStackView = UIStackView(arrangedSubviews: [rankIconLabelView, scoreIconLabelView, heartIconLabelView]).then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 5
    }

    lazy var rankIconLabelView = SimpleIconLabelView(image: UIImage(systemName: "medal.fill"), title: "랭크", description: "46위").then {
        $0.iconImageWrapView.backgroundColor = .white
        $0.iconImageView.tintColor = .systemMint
    }
    
    lazy var scoreIconLabelView = SimpleIconLabelView(image: UIImage(systemName: "star.fill"), title: "점수", description: "8.75").then {
        $0.iconImageWrapView.backgroundColor = .white
        $0.iconImageView.tintColor = .systemYellow
    }
    
    lazy var heartIconLabelView = SimpleIconLabelView(image: UIImage(systemName: "heart.fill"), title: "좋아요", description: "82416").then {
        $0.iconImageWrapView.backgroundColor = .white
        $0.iconImageView.tintColor = .systemPink
    }
    
    lazy var saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)

        $0.setTitleColor(.darkGray, for: .disabled)
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundColor(.lightGray, for: .disabled)
        $0.setBackgroundColor(.purple.withAlphaComponent(0.8), for: .normal)
        $0.layer.cornerRadius = 16
    }

    let customSegmentedControlProperty = CustomSegmentedControlProperty(currentIndex: 0, segmentsTitleLists: ["시놉시스", "배경"])
    lazy var chapterSegmentedControl = CustomSegmentedControl(property: self.customSegmentedControlProperty)
    
    lazy var detailLabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.text = self.item.synopsis
    }

    lazy var detailContainerView = UIView().then {
        $0.backgroundColor = .systemMint
    }
    
    private var chapterVC: ChapterViewController = ChapterViewController()
    private var shortAnimeDetailVC: ShortAnimeDetailViewController = ShortAnimeDetailViewController()
    private var optionVC: OptionViewController = OptionViewController()

    private var item: AnimeDetailData!
    private let disposeBag = DisposeBag()

    init(item: AnimeDetailData) {
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
            if index == 0 {
                self.detailLabel.text = self.item.synopsis
            } else {
                self.detailLabel.text = self.item.background
            }
        }
    }

    override func setupHierarchy() {
        self.view.addSubviews(mainScrollView, backButton)
        self.mainScrollView.addSubviews(headerImageWrapView, mainContentView)
        self.headerImageWrapView.addSubviews(headerImageView, animeTitleLabel)

        self.mainContentView.addSubviews(self.iconLabelStackView, self.chapterSegmentedControl, self.detailLabel)
    }

    override func setupLayout() {
        self.backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(40)
            make.height.equalTo(self.backButton.snp.width)
        }

        self.mainScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.headerImageWrapView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(self.mainContentView.snp.top).priority(.init(900))
            make.width.equalToSuperview()
        }
        
        self.animeTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview().dividedBy(0.6)
            make.bottom.greaterThanOrEqualToSuperview()
        }

        self.headerImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top).priority(.init(900))
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        self.mainContentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(400)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }

        self.iconLabelStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        self.chapterSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(self.iconLabelStackView.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(self.iconLabelStackView.snp.centerX)
        }
        
        self.detailLabel.snp.makeConstraints { make in
            make.top.equalTo(self.chapterSegmentedControl.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    override func setupProperties() {
        self.view.backgroundColor = .systemGray6
        self.animeTitleLabel.text = self.item.title
        self.headerImageView.kf.setImage(with: URL(string: self.item.imageURLs.jpgURLs.largeImageURL))
        
        self.rankIconLabelView.descriptionLabel.text = "\(self.item.rank)위"
        self.scoreIconLabelView.descriptionLabel.text = "\(self.item.score)점"
        self.heartIconLabelView.descriptionLabel.text = "\(self.item.favorites)개"

        self.backButton.rx.tap
            .bind { [weak self] in
                guard let self
                else { return }

                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

    private func updateView(index: Int) {
        chapterVC.view.isHidden = index != 0
        shortAnimeDetailVC.view.isHidden = index != 1
        optionVC.view.isHidden = index != 2
    }
    
    
}
