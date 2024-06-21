//
//  BaseTabBarController.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import CoreData
import UIKit
import RxSwift
import SnapKit
import Then

final class BaseTabBarController: UITabBarController, UIConfigurable {

    private let tabBarNavigationManager = TabBarNavigationManager()
    
    private let customTabBar = CustomTabBar()

    private let animeRepository = DefaultAnimeRepository()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        setupHierarchy()
        setupLayout()
        setupProperties()
        bind()
        view.layoutIfNeeded()
    }

    private func createHomeNavigationController() -> UINavigationController {
        let rootView = HomeViewController(viewModel: DefaultHomeViewModel())
        let nextView = HomeNavigationViewController(rootViewController: rootView)
        nextView.delegate = tabBarNavigationManager

        return nextView
    }

    private func createSearchNavigationController() -> UINavigationController {
        let rootView = SearchViewController(viewModel: makeSearchViewModel())
        let nextView = SearchNavigationViewController(rootViewController: rootView)
        nextView.delegate = tabBarNavigationManager

        return nextView
    }

    private func createMyListNavigationController() -> UINavigationController {
        let rootView = MyListViewController(viewModel: makeMyListViewModel())
        let nextView = MyListNavigationViewController(rootViewController: rootView)
        nextView.delegate = tabBarNavigationManager

        return nextView
    }

    private func createSettingNavigationController() -> UINavigationController {
        let rootView = SettingViewController(viewModel: DefaultSettingViewModel())
        let nextView = SettingNavigationViewController(rootViewController: rootView)
        nextView.delegate = tabBarNavigationManager

        return nextView
    }


    func setupHierarchy() {
        view.addSubview(customTabBar)
    }


    func setupLayout() {
        customTabBar.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(GlobalConstant.customTabBarHeight)
        }
    }

    func setupProperties() {
        tabBar.isHidden = true

        customTabBar.addShadow()

        selectedIndex = 0
        setViewControllers([createHomeNavigationController(), createSearchNavigationController(), createMyListNavigationController(), createSettingNavigationController()], animated: true)

        self.tabBarNavigationManager.delegate = self
    }

    private func selectTabWith(index: Int) {
        self.selectedIndex = index
    }

    private func bind() {
        customTabBar.itemTapped
            .bind { [weak self] in
                guard let self
                else { return }

                self.selectTabWith(index: $0)
            }
            .disposed(by: disposeBag)
    }

}

// MARK: - TabBarNavigationManagerDelegate
extension BaseTabBarController: TabBarNavigationManagerDelegate {

    func customTabbarHidden(hidden: Bool) {
        self.customTabBar.snp.updateConstraints { make in
            make.height.equalTo(hidden ? 0 : GlobalConstant.customTabBarHeight)
        }
    }

}

// MARK: - UITabBarControllerDelegate
extension BaseTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarAnimatedTransitioning()
    }

}

extension BaseTabBarController {

    func makeSearchViewModel() -> SearchViewModel {
        return SearchViewModel(animUseCase: makeAnimeDataUseCase())
    }

    func makeMyListViewModel() -> MyListViewModel {
        return MyListViewModel(animUseCase: makeAnimeDataUseCase(),
                               coreDataUseCase: makeCoreDataUseCase())
    }

    func makeAnimeDataUseCase() -> AnimeDataUseCase {
        return DefaultAnimeUseCase(animeRepository: animeRepository)
    }

    func makeCoreDataUseCase() -> CoreDataUseCase {
        return DefaultCoreDataUseCase()
    }

}
