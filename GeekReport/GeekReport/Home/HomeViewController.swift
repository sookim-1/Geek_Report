//
//  HomeViewController.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit
import SnapKit
import Then

final class HomeViewController: BaseUIViewController {

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        $0.backgroundColor = .systemGroupedBackground
        $0.register(HomeBannerCollectionViewCell.self, forCellWithReuseIdentifier: HomeBannerCollectionViewCell.reuseID)
        $0.dataSource = self
        $0.delegate = self
    }

    private var topAnimeList: [AnimeData] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setupProperties()
    }

    override func setupHierarchy() {
        self.view.addSubview(collectionView)
    }

    override func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func setupProperties() {
        HomeService.shared.getTopAnimes { result in
            switch result {  
            case .success(let success):
                self.topAnimeList = success.dataLists

                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let failure):
                print("\(failure)")
            }
        }
    }

    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(160))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        return UICollectionViewCompositionalLayout(section: section)
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topAnimeList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBannerCollectionViewCell.reuseID, for: indexPath) as! HomeBannerCollectionViewCell

        let item = self.topAnimeList[indexPath.item]

        cell.configureUI(imageURL: item.images.jpgURLs.imageURL, title: item.title)

        return cell
    }

}

