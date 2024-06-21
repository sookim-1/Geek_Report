//
//  AnimeDetailViewController.swift
//  GeekReport
//
//  Created by sookim on 4/26/24.
//

import UIKit
import CoreData
import SnapKit
import Then
import Kingfisher
import RxSwift
import RxCocoa

final class AnimeDetailViewController: BaseUIViewController {

    private lazy var backButton = DefaultBackButton()
    private lazy var mainScrollView = UIScrollView()
    private lazy var headerImageWrapView = UIView()
    private lazy var headerImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }

    private lazy var mainContentView = UIView().then {
        $0.backgroundColor = .systemGray6
    }

    private lazy var mainHeaderView = UIView()

    private lazy var animeTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 34, weight: .heavy)
        $0.textColor = .white
        $0.numberOfLines = 2
        $0.textAlignment = .right
    }
    
    private lazy var iconLabelStackView = UIStackView(arrangedSubviews: [rankIconLabelView, scoreIconLabelView, heartIconLabelView]).then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 5
    }

    private lazy var rankIconLabelView = SimpleIconLabelView(image: UIImage(systemName: "medal.fill"), title: "랭크", description: "46위").then {
        $0.iconImageWrapView.backgroundColor = .white
        $0.iconImageView.tintColor = .systemMint
    }
    
    private lazy var scoreIconLabelView = SimpleIconLabelView(image: UIImage(systemName: "star.fill"), title: "점수", description: "8.75").then {
        $0.iconImageWrapView.backgroundColor = .white
        $0.iconImageView.tintColor = .systemYellow
    }
    
    private lazy var heartIconLabelView = SimpleIconLabelView(image: UIImage(systemName: "heart.fill"), title: "좋아요", description: "82416").then {
        $0.iconImageWrapView.backgroundColor = .white
        $0.iconImageView.tintColor = .systemPink
    }

    private let customSegmentedControlProperty = CustomSegmentedControlProperty(currentIndex: 0, segmentsTitleLists: ["시놉시스", "배경"])
    private lazy var chapterSegmentedControl = CustomSegmentedControl(property: self.customSegmentedControlProperty)

    private lazy var detailLabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }

    private lazy var detailContainerView = UIView().then {
        $0.backgroundColor = .systemMint
    }
    
    private lazy var episodeTextField = UITextField().then {
        $0.placeholder = "에피소드를 선택해주세요!"
        $0.tintColor = .clear
        $0.textColor = .black
        $0.textAlignment = .center
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
    }
    
    private lazy var episodePickerView = UIPickerView().then {
        $0.delegate = self
        $0.dataSource = self
    }
    
    private lazy var saveButton = UIButton().then {
        $0.setBackgroundColor(.systemYellow, for: .normal)
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private lazy var toolBar = UIToolbar().then {
        $0.barStyle = .default
        $0.isTranslucent = true
        $0.tintColor = .black
        $0.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.donePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPicker))
        
        $0.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        $0.isUserInteractionEnabled = true
    }

    private lazy var scrollContentView = UIView()
    private var viewModel: AnimeDetailViewModel!
    
    init(viewModel: AnimeDetailViewModel) {
        super.init()

        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setupProperties()
        bind(to: self.viewModel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let mainContentHeight = self.scrollContentView.systemLayoutSizeFitting(CGSize(width: self.scrollContentView.frame.width, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height
                                                                             
        self.mainContentView.snp.updateConstraints { make in
            make.height.equalTo(mainContentHeight - self.headerImageWrapView.frame.height)
        }
        
        view.layoutIfNeeded()
    }

    override func setupHierarchy() {
        self.view.addSubviews(mainScrollView, backButton)
        self.mainScrollView.addSubviews(self.scrollContentView)
        self.scrollContentView.addSubviews(headerImageWrapView, mainContentView)
        self.headerImageWrapView.addSubviews(headerImageView, animeTitleLabel)
        self.mainContentView.addSubviews(self.iconLabelStackView, self.chapterSegmentedControl, self.detailLabel, self.episodeTextField, self.saveButton)
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
        
        self.scrollContentView.snp.makeConstraints { make in
            make.centerX.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
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
            make.height.equalTo(500)
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
        
        self.episodeTextField.snp.makeConstraints { make in
            make.top.equalTo(self.detailLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(50)
        }
        
        self.saveButton.snp.makeConstraints { make in
            make.top.equalTo(self.detailLabel.snp.bottom).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.leading.equalTo(self.episodeTextField.snp.trailing).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
    }

    override func setupProperties() {
        self.view.backgroundColor = .systemGray6
        self.animeTitleLabel.text = self.viewModel.title
        self.headerImageView.kf.setImage(with: self.viewModel.imagePathURL)
        self.rankIconLabelView.descriptionLabel.text = self.viewModel.rankString
        self.scoreIconLabelView.descriptionLabel.text = self.viewModel.scoreString
        self.heartIconLabelView.descriptionLabel.text = self.viewModel.favouriteString
        self.episodeTextField.inputView = self.episodePickerView
        self.episodeTextField.inputAccessoryView = self.toolBar
        self.mainScrollView.updateContentView()
    }

    private func bind(to viewModel: AnimeDetailViewModel) {
        self.backButton.rx.tap
            .bind { [weak self] in
                guard let self
                else { return }

                self.viewModel.goBack()
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)

        self.saveButton.rx.tap
            .bind { [weak self] in
                guard let self
                else { return }

                if self.episodeTextField.text?.isEmpty == false {
                    self.viewModel.didSaveAnimationData()
                }
            }
            .disposed(by: disposeBag)

        self.chapterSegmentedControl.didTapSegment = { index in
            self.viewModel.didTapSegment(index: index)
        }

        viewModel.selectEpisode
            .observe(on: self) { [weak self] value in
                self?.episodeTextField.text = "\(value)화"
            }

        viewModel.descriptionString
            .observe(on: self) { [weak self] value in
                self?.detailLabel.text = value
                self?.mainScrollView.updateContentView()
            }

        viewModel.isSave
            .observe(on: self) { [weak self] value in
                if value {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
    }

}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension AnimeDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    @objc func donePicker() {
        let row = self.episodePickerView.selectedRow(inComponent: 0)
        self.episodePickerView.selectRow(row, inComponent: 0, animated: false)
        self.episodeTextField.text = "\(self.viewModel.episodes[row])화"
        self.episodeTextField.resignFirstResponder()
    }

    @objc func cancelPicker() {
        self.episodeTextField.text = nil
        self.episodeTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.viewModel.episodes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.viewModel.selectAnimationEpisode(index: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(self.viewModel.episodes[row])화"
    }
    
}
