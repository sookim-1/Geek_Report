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

final class SearchViewController: BaseUIViewController {
    
    private lazy var searchBar = UISearchController().then {
        $0.searchBar.placeholder = "제목을 입력해주세요"
        $0.searchBar.searchBarStyle = .minimal
        $0.searchBar.searchTextField.backgroundColor = .white
        $0.searchBar.tintColor = .white
    }
    
    private lazy var animeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .black
        $0.delegate = self
    }
    
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, DomainAnimeDataModel>
    typealias DataSnapShot = NSDiffableDataSourceSnapshot<Section, DomainAnimeDataModel>
    private var dataSource: DataSource!
    private let animUseCase = DefaultAnimeUseCase(animeRepository: DefaultAnimeRepository())
    private var searchList: [DomainAnimeDataModel] = []
    
    private var searchSubject = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setupProperties()
        configureDataSource()
        applySnapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.searchBar.searchBar.searchTextField.becomeFirstResponder()
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
        searchBar.searchResultsUpdater = self
        navigationItem.searchController = searchBar
        
        searchSubject
            .throttle(.milliseconds(1000), latest: false, scheduler: MainScheduler.instance)
            .subscribe { [weak self] searchText in
                guard let self,
                      let element = searchText.event.element
                else { return }
                
                if element.isEmpty == false {
                    animUseCase.execute(searchText: element)
                        .withUnretained(self)
                        .subscribe { owner, data in
                            self.searchList = data.map { $0.toModel() }

                            DispatchQueue.main.async {
                                self.applySnapshot()
                            }
                        }
                        .disposed(by: disposeBag)

                    /*
                    SearchService.shared.getAnimeSearch(searchString: element) { result in
                        switch result {
                        case .success(let datas):
                            self.searchList = datas
                            
                            DispatchQueue.main.async {
                                self.applySnapshot()
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    */
                }
            }
            .disposed(by: disposeBag)
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

    private func applySnapshot(animated: Bool = true) {
        var snapShot = DataSnapShot()
        snapShot.appendSections([.main])
        snapShot.appendItems(self.searchList)
        
        self.dataSource.apply(snapShot, animatingDifferences: animated)
    }
    
    private func pushToAnimeDetailVC(item: DomainAnimeDataModel) {
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

        animUseCase.execute(animeID: item.animeID)
            .withUnretained(self)
            .subscribe { owner, data in
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(AnimeDetailViewController(item: data.toModel()), animated: true)
                }
            }
            .disposed(by: disposeBag)

    }
    
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.dataSource.itemIdentifier(for: indexPath)
        else { return }

        self.pushToAnimeDetailVC(item: item)
    }

}

// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    
    /// 입력된 텍스트가 변경되거나 사용자가 키보드의 검색 버튼을 탭할 때마다 호출
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        
        self.searchSubject.onNext(query)
    }
    
}
