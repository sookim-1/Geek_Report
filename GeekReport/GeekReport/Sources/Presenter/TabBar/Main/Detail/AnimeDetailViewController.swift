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
    
    lazy var episodeTextField = UITextField().then {
        $0.placeholder = "에피소드를 선택해주세요!"
        $0.tintColor = .black
        $0.textColor = .black
        $0.textAlignment = .center
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
    }
    
    lazy var episodePickerView = UIPickerView().then {
        $0.delegate = self
        $0.dataSource = self
    }
    
    lazy var saveButton = UIButton().then {
        $0.setBackgroundColor(.systemYellow, for: .normal)
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    lazy var toolBar = UIToolbar().then {
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
    
    private var item: DomainAnimeDetailDataModel!
    private var episodes: [Int] = []
    private var selectEpisode = 1
    
    lazy var scrollContentView = UIView()
    private var container: NSPersistentContainer!
    
    private let disposeBag = DisposeBag()

    init(item: DomainAnimeDetailDataModel) {
        self.item = item
        
        if let itemEpisodes = item.episodes,
                itemEpisodes > 0 {
            self.episodes = Array(1...itemEpisodes)
        }
        
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

        self.chapterSegmentedControl.didTapSegment = { index in
            self.detailLabel.text = (index == 0) ? self.item.synopsis : self.item.background
        }
        mainScrollView.updateContentView()
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
        self.animeTitleLabel.text = self.item.title
        self.headerImageView.kf.setImage(with: URL(string: self.item.imageURLString))

        self.rankIconLabelView.descriptionLabel.text = (self.item.rank != nil) ? "\(self.item.rank!)" : "미정"
        self.scoreIconLabelView.descriptionLabel.text = "\(self.item.score)"
        self.heartIconLabelView.descriptionLabel.text = "\(self.item.favorites.formatThousandString)"

        self.backButton.rx.tap
            .bind { [weak self] in
                guard let self
                else { return }

                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        self.episodeTextField.inputView = self.episodePickerView
        self.episodeTextField.inputAccessoryView = self.toolBar
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
        self.saveButton.rx.tap
            .bind { [weak self] in
                guard let self
                else { return }
                
                if self.episodeTextField.text?.isEmpty == false {
                    guard let entity = NSEntityDescription.entity(forEntityName: "AnimeEntities", in: self.container.viewContext)
                    else { return }
                    
                    let item = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
                    
                    item.setValue("\(self.item.title)", forKey: "title")
                    item.setValue("\(self.item.imageURLString)", forKey: "imageURL")
                    item.setValue(Int64(self.selectEpisode), forKey: "episodes")
                    item.setValue(Int64(self.item.animeID), forKey: "malID")
                    
                    do {
                        try self.container.viewContext.save()
                        self.navigationController?.popViewController(animated: true)
                    } catch {
                        print("코어데이터 저장 오류 발생")
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: -
extension AnimeDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    @objc func donePicker() {
        let row = self.episodePickerView.selectedRow(inComponent: 0)
        self.episodePickerView.selectRow(row, inComponent: 0, animated: false)
        self.episodeTextField.text = "\(self.episodes[row])화"
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
        self.episodes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectEpisode = self.episodes[row]
        self.episodeTextField.text = "\(self.episodes[row])화"
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(self.episodes[row])화"
    }
    
}

extension UIScrollView {
    func updateContentSize() {
        let unionCalculatedTotalRect = recursiveUnionInDepthFor(view: self)
        
        // 계산된 크기로 컨텐츠 사이즈 설정
        self.contentSize = CGSize(width: self.frame.width, height: unionCalculatedTotalRect.height+50)
    }
    
    private func recursiveUnionInDepthFor(view: UIView) -> CGRect {
        var totalRect: CGRect = .zero
        
        // 모든 자식 View의 컨트롤의 크기를 재귀적으로 호출하며 최종 영역의 크기를 설정
        for subView in view.subviews {
            totalRect = totalRect.union(recursiveUnionInDepthFor(view: subView))
        }
        
        // 최종 계산 영역의 크기를 반환
        return totalRect.union(view.frame)
    }
    
    
}

extension UIScrollView {
   func updateContentView() {
      contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
   }
}
