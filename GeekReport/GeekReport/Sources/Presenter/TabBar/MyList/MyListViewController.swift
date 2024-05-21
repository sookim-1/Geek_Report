//
//  MyListViewController.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit
import CoreData
import SnapKit
import Then
import Kingfisher
import RxSwift
import RxCocoa

final class MyListViewController: BaseUIViewController {
    
    private lazy var animeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .black
    }
    
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnimeEntities>
    typealias DataSnapShot = NSDiffableDataSourceSnapshot<Section, AnimeEntities>
    
    private var dataSource: DataSource!
    private let viewModel: MyListViewModel

    init(viewModel: MyListViewModel) {
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
        self.view.addSubviews(animeCollectionView)
    }

    override func setupLayout() {
        animeCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-GlobalConstant.customTabBarHeight)
        }
    }

    override func setupProperties() {
        let input = MyListViewModel.Input(viewWillappear: self.rx.viewWillAppear.map {_ in },
                                          selectAnime: self.transformSelectedItemToInput())
        let output = viewModel.transform(input: input)

        output.myAnimeList
            .drive(onNext: { [weak self] datas in
                self?.applySnapshot(items: datas)
            })
            .disposed(by: disposeBag)

        output.selectAnimeDone
            .subscribe { [weak self] data in
                self?.pushToAnimeDetailVC(item: data.toModel())
            }
            .disposed(by: disposeBag)
    }

    private func transformSelectedItemToInput() -> Observable<Int> {
        return self.animeCollectionView.rx.itemSelected
            .asObservable()
            .compactMap { [weak self] i -> Int? in
                guard let item = self?.dataSource.itemIdentifier(for: i)
                else{ return nil }

                return Int(item.malID)
            }
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SearchListCell, AnimeEntities> { (cell, indexPath, item) in
            cell.imageView.kf.setImage(with: URL(string: item.imageURL ?? ""))
            cell.titleLabel.text = item.title
            
            cell.episodeLabel.isHidden = false
            cell.episodeLabel.text = "시청 중인 에피소드 : \(item.episodes) 화"
        }

        self.dataSource = DataSource(collectionView: self.animeCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
    }

    private func applySnapshot(items: [AnimeEntities], animated: Bool = true) {
        var snapShot = DataSnapShot()
        snapShot.appendSections([.main])
        snapShot.appendItems(items)

        self.dataSource.apply(snapShot, animatingDifferences: animated)
    }
    
    private func pushToAnimeDetailVC(item: DomainAnimeDetailDataModel) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(AnimeDetailViewController(item: item), animated: true)
        }
    }
    
}
