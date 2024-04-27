//
//  TempHomeViewController.swift
//  GeekReport
//
//  Created by sookim on 4/26/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

// FIXME: - ItemModel을 AnimeData모델로 변경, CustomCell 작성
final class TempHomeViewController: BaseUIViewController {

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .black
        $0.delegate = self
    }

    enum Section: CaseIterable {
        case carousel
        case recommend
        case spring
        case summer
        case autumn
        case winter
    }

    typealias HomeDataSource = UICollectionViewDiffableDataSource<Section, AnimeData>
    typealias HomeDataSnapShot = NSDiffableDataSourceSnapshot<Section, AnimeData>
    private var homeDataSource: HomeDataSource!
    private var titleHeaderRegistration: UICollectionView.SupplementaryRegistration<UICollectionViewListCell>!
    private var pageFooterRegistration: UICollectionView.SupplementaryRegistration<PagingSectionFooterView>!
    private let pagingInfoSubject = PublishSubject<PagingInfo>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setupProperties()
        configureDataSource()
        applySnapshot()
    }

    override func setupHierarchy() {
        self.view.addSubviews(self.collectionView)
    }

    override func setupLayout() {
        self.collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-GlobalConstant.customTabBarHeight)
        }
    }

    override func setupProperties() {
        self.view.backgroundColor = .black
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            switch sectionIndex {
            case 0: return self.createCarouselSection()
            default: return self.createBasicSection()
            }
        }

        return layout
    }

    private func configureDataSource() {
        let carouselCellRegistration = UICollectionView.CellRegistration<AnimeBannerCollectionViewCell, AnimeData> { (cell, indexPath, item) in
            cell.imageView.kf.setImage(with: URL(string: item.imageURLs.jpgURLs.largeImageURL))
            cell.titleLabel.text = item.title
        }
        
        let cellRegistration = UICollectionView.CellRegistration<AnimeCollectionViewCell, AnimeData> { (cell, indexPath, item) in
            cell.imageView.kf.setImage(with: URL(string: item.imageURLs.jpgURLs.largeImageURL))
            cell.titleLabel.text = item.title
        }

        self.homeDataSource = HomeDataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            if indexPath.section == 0 {
                return collectionView.dequeueConfiguredReusableCell(using: carouselCellRegistration, for: indexPath, item: itemIdentifier)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            }
        })

        // MARK: - SupplementaryView
        self.titleHeaderRegistration = .init(elementKind: UICollectionView.elementKindSectionHeader) { (supplementaryView, elementKind, indexPath) in
            var content = supplementaryView.defaultContentConfiguration()
            content.text = "제목"
            content.textProperties.color = .white
            supplementaryView.contentConfiguration = content
        }

        self.pageFooterRegistration = .init(elementKind: UICollectionView.elementKindSectionFooter) { [unowned self]
            (pagingFooter, elementKind, indexPath) in
            let itemCount = self.homeDataSource.snapshot().numberOfItems(inSection: .carousel)
            
            pagingFooter.configure(numberOfPages: itemCount, indexPath: indexPath, delegate: self)
            pagingFooter.subscribeTo(subject: self.pagingInfoSubject, for: indexPath.section)
        }

        self.homeDataSource.supplementaryViewProvider = { (collectionView, elementKind, indexPath) in
            switch elementKind {
            case UICollectionView.elementKindSectionHeader:
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: self.titleHeaderRegistration, for: indexPath)
            case UICollectionView.elementKindSectionFooter:
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: self.pageFooterRegistration, for: indexPath)
            default:
                return UICollectionReusableView()
            }
        }
    }

    private func applySnapshot(animated: Bool = true) {
        var snapShot = HomeDataSnapShot()
        snapShot.appendSections(Section.allCases)

        Section.allCases.forEach {
            snapShot.appendItems(AnimeData.defaultData, toSection: $0)
        }
        
        self.homeDataSource.apply(snapShot, animatingDifferences: animated)
    }

}

// MARK: - Layout
extension TempHomeViewController {

    private func createCarouselSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(490))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        //MARK: - SupplementaryView
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(20))

        let pagingFooterElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        section.boundarySupplementaryItems += [pagingFooterElement]

        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            // MARK: - Animation
            let width = environment.container.contentSize.width //* 0.9 - 8

            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - width / 2.0)
                let minScale: CGFloat = 0.9
                let maxScale: CGFloat = minScale + (1.0 - minScale) * exp(-distanceFromCenter / width)
                let scale = max(maxScale, minScale)
                let cell = self.collectionView.cellForItem(at: item.indexPath)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
                cell?.transform = CGAffineTransform(scaleX: scale, y: scale)
            }

            // MARK: - Paging
            let page = round(offset.x / self.view.bounds.width)
            self.pagingInfoSubject.onNext(PagingInfo(currentPage: Int(page)))
        }

        return section
    }

    private func createBasicSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 10)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.35), heightDimension: .fractionalWidth(0.55))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous

        //MARK: - SupplementaryView
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))

        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        section.boundarySupplementaryItems += [headerElement]

        return section
    }

}

// MARK: - PagerDelegate
extension TempHomeViewController: PagerDelegate {
    func didValueChanged(indexPath: IndexPath, scrollPosition: UICollectionView.ScrollPosition) {
        self.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: true)
    }
}

// MARK: -
extension TempHomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.homeDataSource.itemIdentifier(for: indexPath)
        else { return }

        self.navigationController?.pushViewController(AnimeDetailViewController(item: item), animated: true)
    }

}

#Preview {
    TempHomeViewController()
}
