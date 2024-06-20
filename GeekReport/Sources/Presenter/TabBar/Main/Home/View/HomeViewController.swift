//
//  HomeViewController.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

enum Season: String, CaseIterable {
    case spring = "spring"
    case summer = "summer"
    case autumn = "fall"
    case winter = "winter"
}

// FIXME: - ItemModel을 AnimeData모델로 변경, CustomCell 작성
final class HomeViewController: BaseUIViewController {

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = .black
        $0.delegate = self
        $0.alpha = 0
    }

    enum Section: CaseIterable {
        case carousel
        case recommend
        case spring
        case summer
        case autumn
        case winter
        
        var title: String {
            switch self {
            case .carousel: ""
            case .recommend: "Top 10"
            case .spring: "\(GlobalDateFormmater.shared.currentYear) 1분기"
            case .summer: "\(GlobalDateFormmater.shared.currentYear) 2분기"
            case .autumn: "\(GlobalDateFormmater.shared.currentYear) 3분기"
            case .winter: "\(GlobalDateFormmater.shared.currentYear) 4분기"
            }
        }
    }

    typealias HomeDataSource = UICollectionViewDiffableDataSource<Section, DomainAnimeDataModel>
    typealias HomeDataSnapShot = NSDiffableDataSourceSnapshot<Section, DomainAnimeDataModel>
    private var homeDataSource: HomeDataSource!
    private var titleHeaderRegistration: UICollectionView.SupplementaryRegistration<SectionTitleHeaderView>!
    private var pageFooterRegistration: UICollectionView.SupplementaryRegistration<PagingSectionFooterView>!
    private let pagingInfoSubject = PublishSubject<PagingInfo>()

    private var animeRecommendationLists: [DomainAnimeDataModel] = []
    private var animeTopLists: [DomainAnimeDataModel] = []
    private var animeSpringLists: [DomainAnimeDataModel] = []
    private var animeSummerLists: [DomainAnimeDataModel] = []
    private var animeAutumnLists: [DomainAnimeDataModel] = []
    private var animeWinterLists: [DomainAnimeDataModel] = []

    private let recommendationUseCase = DefaultRecommendationUseCase(recommendationRepository: DefaultRecommendationRepository())
    private let seasonUseCase = DefaultSeasonAnimeUseCase(seasonRepository: DefaultSeasonRepository())
    private let topUseCase = DefaultTopAnimeUseCase(topRepository: DefaultTopRepository())
    private let animUseCase = DefaultAnimeUseCase(animeRepository: DefaultAnimeRepository())
    private let animeRepository = DefaultAnimeRepository()

    private var viewModel: HomeViewModel!

    init(viewModel: HomeViewModel) {
        super.init()

        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setupProperties()
        configureDataSource()
        applySnapshot()

        self.requestGetRecentAnimeRecommendations()
        self.requestGetTopAnime()
        self.requestGetSpringSeasonAnime()
        self.requestGetSummerSeasonAnime()
        self.requestGetAutumnSeasonAnime()
        self.requestGetWinterSeasonAnime()

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.collectionView.alpha = 1
            self.applySnapshot()
        }

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
        let carouselCellRegistration = UICollectionView.CellRegistration<AnimeBannerCollectionViewCell, DomainAnimeDataModel> { (cell, indexPath, item) in
            cell.imageView.kf.setImage(with: URL(string: item.imageURLString))
            cell.titleLabel.text = item.title
        }
        
        let cellRegistration = UICollectionView.CellRegistration<AnimeCollectionViewCell, DomainAnimeDataModel> { (cell, indexPath, item) in
            cell.imageView.kf.setImage(with: URL(string: item.imageURLString))
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
            supplementaryView.sectionTitleLabel.text = self.homeDataSource.sectionIdentifier(for: indexPath.section)?.title
            supplementaryView.moreButton.rx.tap.bind { [weak self] _ in
                guard let self
                else { return }

                let section = self.homeDataSource.sectionIdentifier(for: indexPath.section)
                switch section {
                case .recommend:
                    self.pushToMoreAnimeVC(items: self.animeTopLists)
                case .spring:
                    self.pushToMoreAnimeVC(items: self.animeSpringLists)
                case .summer:
                    self.pushToMoreAnimeVC(items: self.animeSummerLists)
                case .autumn:
                    self.pushToMoreAnimeVC(items: self.animeAutumnLists)
                case .winter:
                    self.pushToMoreAnimeVC(items: self.animeWinterLists)
                default:
                    print("Not Push")
                }
            }
            .disposed(by: supplementaryView.disposeBag)
        }

        self.pageFooterRegistration = .init(elementKind: UICollectionView.elementKindSectionFooter) { [unowned self]
            (pagingFooter, elementKind, indexPath) in
            pagingFooter.configure(numberOfPages: 5, indexPath: indexPath, delegate: self)
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
            switch $0 {
            case .carousel:
                snapShot.appendItems(self.animeRecommendationLists, toSection: $0)
            case .recommend:
                snapShot.appendItems(self.animeTopLists, toSection: $0)
            case .spring:
                snapShot.appendItems(self.animeSpringLists, toSection: $0)
            case .summer:
                snapShot.appendItems(self.animeSummerLists, toSection: $0)
            case .autumn:
                snapShot.appendItems(self.animeAutumnLists, toSection: $0)
            case .winter:
                snapShot.appendItems(self.animeWinterLists, toSection: $0)
            }
        }
        
        self.homeDataSource.apply(snapShot, animatingDifferences: animated)
    }

}

// MARK: - Layout
extension HomeViewController {

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
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60))

        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        section.boundarySupplementaryItems += [headerElement]

        return section
    }

    private func pushToAnimeDetailVC(item: DomainAnimeDataModel) {
        animUseCase.execute(animeID: item.animeID)
            .withUnretained(self)
            .subscribe { owner, data in
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(AnimeDetailViewController(viewModel: DefaultAnimeDetailViewModel(item: data)), animated: true)
                }
            }
            .disposed(by: disposeBag)
    }

    private func pushToMoreAnimeVC(items: [DomainAnimeDataModel]) {
        self.navigationController?.pushViewController(MoreAnimeViewController(viewModel: makeMoreAnimeViewModel(items: items)), animated: true)
    }

    func makeMoreAnimeViewModel(items: [DomainAnimeDataModel]) -> MoreAnimeViewModel {
        return MoreAnimeViewModel(animUseCase: makeAnimeDataUseCase(), animeLists: items)
    }

    func makeAnimeDataUseCase() -> AnimeDataUseCase {
        return DefaultAnimeUseCase(animeRepository: animeRepository)
    }

}

// MARK: - PagerDelegate
extension HomeViewController: PagerDelegate {
    func didValueChanged(indexPath: IndexPath, scrollPosition: UICollectionView.ScrollPosition) {
        self.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: true)
    }
}

// MARK: -
extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.homeDataSource.itemIdentifier(for: indexPath)
        else { return }

        self.pushToAnimeDetailVC(item: item)
    }

}

// MARK: - API
extension HomeViewController {

    private func requestGetRecentAnimeRecommendations() {
        recommendationUseCase.execute()
            .withUnretained(self)
            .subscribe { owner, data in
                self.animeRecommendationLists = data.map { $0 }
            }
            .disposed(by: disposeBag)
    }

    private func requestGetTopAnime() {
        topUseCase.execute()
            .withUnretained(self)
            .subscribe { owner, data in
                self.animeTopLists = data.map { $0 }
            }
            .disposed(by: disposeBag)
    }

    private func requestGetSpringSeasonAnime() {
        seasonUseCase.execute(season: .spring)
            .withUnretained(self)
            .subscribe { owner, data in
                self.animeSpringLists = data.map { $0 }
            }
            .disposed(by: disposeBag)
    }

    private func requestGetSummerSeasonAnime() {
        seasonUseCase.execute(season: .summer)
            .withUnretained(self)
            .subscribe { owner, data in
                self.animeSummerLists = data.map { $0 }
            }
            .disposed(by: disposeBag)
    }

    private func requestGetAutumnSeasonAnime() {
        
        seasonUseCase.execute(season: .autumn)
            .withUnretained(self)
            .subscribe { owner, data in
                self.animeAutumnLists = data.map { $0 }
            }
            .disposed(by: disposeBag)
    }

    private func requestGetWinterSeasonAnime() {
        seasonUseCase.execute(season: .winter)
            .withUnretained(self)
            .subscribe { owner, data in
                self.animeWinterLists = data.map { $0 }
            }
            .disposed(by: disposeBag)
    }

}
