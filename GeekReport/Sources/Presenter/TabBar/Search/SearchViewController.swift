//
//  SearchViewController.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import RxSwift
import RxCocoa

final class SearchViewController: BaseUIViewController {
    
    private lazy var searchController = UISearchController().then {
        $0.searchBar.placeholder = "제목을 입력해주세요"
        $0.searchBar.searchBarStyle = .minimal
        $0.searchBar.searchTextField.backgroundColor = .white
        $0.searchBar.tintColor = .white
    }
    
    private lazy var animeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .black
    }
    
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, DomainAnimeDataModel>
    typealias DataSnapShot = NSDiffableDataSourceSnapshot<Section, DomainAnimeDataModel>
    private var dataSource: DataSource!

    private let viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel

        super.init()
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setupProperties()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.searchController.searchBar.searchTextField.becomeFirstResponder()
    }

    override func setupHierarchy() {
        self.view.addSubview(animeCollectionView)
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
        navigationItem.searchController = searchController

        let input = SearchViewModel.Input(searchAnime: self.transformSearchTextToInput(),
                                          selectAnime: self.transformSelectedItemToInput())

        let output = viewModel.transform(input: input)

        output.searchList
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

    private func transformSearchTextToInput() -> Observable<String> {
        return self.searchController.searchBar.rx.text
            .filter { $0?.isEmpty == false }
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .asObservable()
            .compactMap { $0 }
    }

    private func transformSelectedItemToInput() -> Observable<Int> {
        return self.animeCollectionView.rx.itemSelected
            .asObservable()
            .compactMap { [weak self] i -> Int? in
                guard let item = self?.dataSource.itemIdentifier(for: i)
                else{ return nil }

                return Int(item.animeID)
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
        let cellRegistration = UICollectionView.CellRegistration<SearchListCell, DomainAnimeDataModel> { (cell, indexPath, item) in
            cell.imageView.kf.setImage(with: URL(string: item.imageURLString))
            cell.titleLabel.text = item.title
            
            if let episodes = item.episodes {
                cell.episodeLabel.isHidden = false
                cell.episodeLabel.text = "총 에피소드 : \(episodes) 화"
            } else {
                cell.episodeLabel.isHidden = true
            }
        }

        self.dataSource = DataSource(collectionView: self.animeCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
    }

    private func applySnapshot(items: [DomainAnimeDataModel], animated: Bool = true) {
        var snapShot = DataSnapShot()
        snapShot.appendSections([.main])
        snapShot.appendItems(items)

        self.dataSource.apply(snapShot, animatingDifferences: animated)
    }
    
    private func pushToAnimeDetailVC(item: DomainAnimeDetailDataModel) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(AnimeDetailViewController(viewModel: DefaultAnimeDetailViewModel(item: item)), animated: true)
        }
    }
    
}
