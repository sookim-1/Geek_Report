//
//  MoreAnimeViewController.swift
//  GeekReport
//
//  Created by sookim on 5/2/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class MoreAnimeViewController: BaseUIViewController {

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .black
        $0.delegate = self
    }

    lazy var backButton = DefaultBackButton()

    enum Section {
        case main
    }

    typealias HomeDataSource = UICollectionViewDiffableDataSource<Section, DomainAnimeDataModel>
    typealias HomeDataSnapShot = NSDiffableDataSourceSnapshot<Section, DomainAnimeDataModel>
    private var homeDataSource: HomeDataSource!
    private var animeLists: [DomainAnimeDataModel]!
    private let animUseCase = DefaultAnimeUseCase(animeRepository: DefaultAnimeRepository())
    private let disposeBag = DisposeBag()

    init(animeLists: [DomainAnimeDataModel]) {
        self.animeLists = animeLists
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
        configureDataSource()
        applySnapshot()
    }
    

    override func setupHierarchy() {
        self.view.addSubviews(self.collectionView, self.backButton)
    }

    override func setupLayout() {
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.backButton.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        self.backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(40)
            make.height.equalTo(self.backButton.snp.width)
        }
    }

    override func setupProperties() {
        self.backButton.rx.tap
            .bind { [weak self] in
                guard let self
                else { return }

                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            return self.createBasicSection()
        }

        return layout
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<AnimeCollectionViewCell, DomainAnimeDataModel> { (cell, indexPath, item) in
            cell.imageView.kf.setImage(with: URL(string: item.imageURLString))
            cell.titleLabel.text = item.title
        }

        self.homeDataSource = HomeDataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
    }

    private func applySnapshot(animated: Bool = true) {
        var snapShot = HomeDataSnapShot()
        snapShot.appendSections([.main])
        snapShot.appendItems(self.animeLists)
        self.homeDataSource.apply(snapShot, animatingDifferences: animated)
    }

    private func createBasicSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.bottom = 20

        return section
    }

    private func pushToAnimeDetailVC(item: DomainAnimeDataModel) {
        animUseCase.execute(animeID: item.animeID)
            .withUnretained(self)
            .subscribe { owner, data in
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(AnimeDetailViewController(item: data.toModel()), animated: true)
                }
            }
            .disposed(by: disposeBag)
        /*
        HomeService.shared.getAnimeID(animeID: item.animeID) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(AnimeDetailViewController(item: data), animated: true)
                }
            case .failure(let error):
                if error == .unknownError {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "에러", message: "해당 애니메이션은 접근이 불가합니다.\n참고 ID : \(item.animeID)", preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
         */
    }

}

extension MoreAnimeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.homeDataSource.itemIdentifier(for: indexPath)
        else { return }

        self.pushToAnimeDetailVC(item: item)
    }

}
