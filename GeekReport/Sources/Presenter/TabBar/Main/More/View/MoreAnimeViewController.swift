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
    }

    lazy var backButton = DefaultBackButton()

    enum Section {
        case main
    }

    typealias HomeDataSource = UICollectionViewDiffableDataSource<Section, DomainAnimeDataModel>
    typealias HomeDataSnapShot = NSDiffableDataSourceSnapshot<Section, DomainAnimeDataModel>
    private var homeDataSource: HomeDataSource!

    private let viewModel: MoreAnimeViewModel

    init(viewModel: MoreAnimeViewModel) {
        self.viewModel = viewModel

        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        configureDataSource()
        setupProperties()
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

        let input = MoreAnimeViewModel.Input(selectAnime: self.transformSelectedItemToInput())

        let output = viewModel.transform(input: input)

        output.moreAnimeList
            .subscribe(onNext: { [weak self] datas in
                self?.applySnapshot(items: datas.map { $0 })
            })
            .disposed(by: disposeBag)

        output.selectAnimeDone
            .subscribe { [weak self] data in
                self?.pushToAnimeDetailVC(item: data)
            }
            .disposed(by: disposeBag)
    }

    private func transformSelectedItemToInput() -> Observable<Int> {
        return self.collectionView.rx.itemSelected
            .asObservable()
            .compactMap { [weak self] i -> Int? in
                guard let item = self?.homeDataSource.itemIdentifier(for: i)
                else{ return nil }

                return Int(item.animeID)
            }
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

    private func applySnapshot(items: [DomainAnimeDataModel], animated: Bool = true) {
        var snapShot = HomeDataSnapShot()
        snapShot.appendSections([.main])
        snapShot.appendItems(items)
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

    private func pushToAnimeDetailVC(item: DomainAnimeDetailDataModel) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(AnimeDetailViewController(viewModel: DefaultAnimeDetailViewModel(item: item)), animated: true)
        }
    }

}
