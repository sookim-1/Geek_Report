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

class ItemModel: Hashable {

    var uuid = UUID()
    let text: String

    init(text: String) {
        self.text = text
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    static func == (lhs: ItemModel, rhs: ItemModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }

}

// FIXME: - ItemModel을 AnimeData모델로 변경, CustomCell 작성
final class TempHomeViewController: BaseUIViewController {

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .systemRed
    }

    enum Section: CaseIterable {
        case carousel
        case recommend
        case spring
        case summer
        case autumn
        case winter
    }

    typealias HomeDataSource = UICollectionViewDiffableDataSource<Section, ItemModel>
    typealias HomeDataSnapShot = NSDiffableDataSourceSnapshot<Section, ItemModel>
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
            make.edges.equalToSuperview()
        }
    }

    override func setupProperties() {

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
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ItemModel> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.text
            content.textProperties.alignment = .center
            cell.contentConfiguration = content
        }

        self.homeDataSource = HomeDataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })

        // MARK: - SupplementaryView
        self.titleHeaderRegistration = .init(elementKind: UICollectionView.elementKindSectionHeader) { (supplementaryView, elementKind, indexPath) in
            var content = supplementaryView.defaultContentConfiguration()
            content.text = "제목"
            content.textProperties.alignment = .center
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

        let items = (0..<5).map(\.description)

        items.enumerated().forEach { index, item in
            Section.allCases.forEach {
                snapShot.appendItems([ItemModel(text: item)], toSection: $0)
            }
        }
        
        self.homeDataSource.apply(snapShot, animatingDifferences: animated)
    }

}

// MARK: - Layout
extension TempHomeViewController {

    private func createCarouselSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(0.5))
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 10)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
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

#Preview {
    TempHomeViewController() 
}
