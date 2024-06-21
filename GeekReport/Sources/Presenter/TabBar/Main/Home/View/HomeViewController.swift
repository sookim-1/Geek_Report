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

    private let animeRepository = DefaultAnimeRepository()

    private lazy var loadingView = CustomLoadingView(colors: [.systemRed, .systemGreen, .systemBlue], lineWidth: 5)
    private var networkDelayTime: TimeInterval = 1
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

        self.viewModel.requestGetRecentAnimeRecommendations()
        self.bind(to: viewModel)
    }

    override func setupHierarchy() {
        self.view.addSubviews(self.collectionView, self.loadingView)
        self.view.bringSubviewToFront(self.loadingView)
    }

    override func setupLayout() {
        self.collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-GlobalConstant.customTabBarHeight)
        }

        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }

    override func setupProperties() {
        
    }

    private func bind(to viewModel: HomeViewModel) {
        viewModel.animeRecommendationLists.observe(on: self, skipInitial: true) { [weak self] value in
            guard let self
            else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + self.networkDelayTime) {
                AppLogger.log(tag: .error, "API 제한 : \(self.networkDelayTime)초후 데이터 호출")
             
                if value.isEmpty {
                    self.viewModel.requestGetRecentAnimeRecommendations()
                } else {
                    AppLogger.log(tag: .success, "완료")
                    self.viewModel.requestGetTopAnime()
                }
            }
        }

        viewModel.animeTopLists.observe(on: self, skipInitial: true) { [weak self] value in
            guard let self
            else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + self.networkDelayTime) {
                AppLogger.log(tag: .error, "API 제한 : \(self.networkDelayTime)초후 데이터 호출")

                if value.isEmpty {
                    self.viewModel.requestGetTopAnime()
                } else {
                    AppLogger.log(tag: .success, "완료")
                    self.viewModel.requestGetSpringSeasonAnime()
                }
            }
        }

        viewModel.animeSpringLists.observe(on: self, skipInitial: true) { [weak self] value in
            guard let self
            else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + self.networkDelayTime) {
                AppLogger.log(tag: .error, "API 제한 : \(self.networkDelayTime)초후 데이터 호출")

                if value.isEmpty {
                    self.viewModel.requestGetSpringSeasonAnime()
                } else {
                    AppLogger.log(tag: .success, "완료")
                    self.viewModel.requestGetSummerSeasonAnime()
                }
            }
        }

        viewModel.animeSummerLists.observe(on: self, skipInitial: true) { [weak self] value in
            guard let self
            else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + self.networkDelayTime) {
                AppLogger.log(tag: .error, "API 제한 : \(self.networkDelayTime)초후 데이터 호출")

                if value.isEmpty {
                    self.viewModel.requestGetSummerSeasonAnime()
                } else {
                    AppLogger.log(tag: .success, "완료")
                    self.viewModel.requestGetAutumnSeasonAnime()
                }
            }
        }

        viewModel.animeAutumnLists.observe(on: self, skipInitial: true) { [weak self] value in
            guard let self
            else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + self.networkDelayTime) {
                AppLogger.log(tag: .error, "API 제한 : \(self.networkDelayTime)초후 데이터 호출")

                if value.isEmpty {
                    self.viewModel.requestGetAutumnSeasonAnime()
                } else {
                    AppLogger.log(tag: .success, "완료")
                    self.viewModel.requestGetWinterSeasonAnime()
                }
            }
        }

        viewModel.animeWinterLists.observe(on: self, skipInitial: true) { [weak self] value in
            guard let self
            else { return }

            DispatchQueue.main.asyncAfter(deadline: .now() + self.networkDelayTime) {
                AppLogger.log(tag: .error, "API 제한 : \(self.networkDelayTime)초후 데이터 호출")

                if value.isEmpty {
                    self.viewModel.requestGetWinterSeasonAnime()
                }
            }
        }

        viewModel.isLoad.observe(on: self) { [weak self] isComplete in
            let logMessage = (isComplete) ? "모든 API 호출 작업 완료" : "로딩 시작"
            AppLogger.log(tag: .success, logMessage)

            DispatchQueue.main.async {
                self?.loadingView.isAnimating = !isComplete
                self?.collectionView.isHidden = !isComplete
                self?.applySnapshot()
            }
        }

        viewModel.isCompleteAnimeDetailData.observe(on: self, skipInitial: true) { [weak self] data in
            AppLogger.log(tag: .success, "AnimeDetail 화면 전환")

            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(AnimeDetailViewController(viewModel: DefaultAnimeDetailViewModel(item: data)), animated: true)
            }
        }
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
                    self.pushToMoreAnimeVC(items: self.viewModel.animeTopLists.value)
                case .spring:
                    self.pushToMoreAnimeVC(items: self.viewModel.animeSpringLists.value)
                case .summer:
                    self.pushToMoreAnimeVC(items: self.viewModel.animeSummerLists.value)
                case .autumn:
                    self.pushToMoreAnimeVC(items: self.viewModel.animeAutumnLists.value)
                case .winter:
                    self.pushToMoreAnimeVC(items: self.viewModel.animeWinterLists.value)
                default:
                    print("Not Push")
                }
            }
            .disposed(by: supplementaryView.disposeBag)
        }

        self.pageFooterRegistration = .init(elementKind: UICollectionView.elementKindSectionFooter) { [unowned self]
            (pagingFooter, elementKind, indexPath) in
            pagingFooter.configure(numberOfPages: 5, indexPath: indexPath, delegate: self)
            pagingFooter.subscribeTo(subject: self.viewModel.pagingInfoSubject, for: indexPath.section)
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
                snapShot.appendItems(self.viewModel.animeRecommendationLists.value, toSection: $0)
            case .recommend:
                snapShot.appendItems(self.viewModel.animeTopLists.value, toSection: $0)
            case .spring:
                snapShot.appendItems(self.viewModel.animeSpringLists.value, toSection: $0)
            case .summer:
                snapShot.appendItems(self.viewModel.animeSummerLists.value, toSection: $0)
            case .autumn:
                snapShot.appendItems(self.viewModel.animeAutumnLists.value, toSection: $0)
            case .winter:
                snapShot.appendItems(self.viewModel.animeWinterLists.value, toSection: $0)
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
            self.viewModel.didCurrentPage(page: Int(page))
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

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.homeDataSource.itemIdentifier(for: indexPath)
        else { return }
        
        self.viewModel.didSelectItem(item.animeID)
    }

}
