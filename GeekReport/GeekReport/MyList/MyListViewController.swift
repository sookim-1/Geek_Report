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

final class MyListViewController: BaseUIViewController {
    
    private lazy var animeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .black
        $0.delegate = self
    }
    
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnimeEntities>
    typealias DataSnapShot = NSDiffableDataSourceSnapshot<Section, AnimeEntities>
    private var dataSource: DataSource!
    private var myAnimeList: [AnimeEntities] = []

    private var container: NSPersistentContainer!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setupProperties()
        configureDataSource()
        applySnapshot()
        
        do {
            let contact = try self.container.viewContext.fetch(AnimeEntities.fetchRequest()) 
            
            self.myAnimeList = contact
            self.applySnapshot()
        } catch {
            print(error.localizedDescription)
        }
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
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

    private func applySnapshot(animated: Bool = true) {
        var snapShot = DataSnapShot()
        snapShot.appendSections([.main])
        snapShot.appendItems(self.myAnimeList)
        
        self.dataSource.apply(snapShot, animatingDifferences: animated)
    }
    
    private func pushToAnimeDetailVC(item: AnimeEntities) {
        HomeService.shared.getAnimeID(animeID: Int(item.malID)) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(AnimeDetailViewController(item: data), animated: true)
                }
            case .failure(let error):
                if error == .unknownError {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "에러", message: "해당 애니메이션은 접근이 불가합니다.\n참고 ID : \(item.malID)", preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}

// MARK: - UICollectionViewDelegate
extension MyListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.dataSource.itemIdentifier(for: indexPath)
        else { return }

        self.pushToAnimeDetailVC(item: item)
    }

}

