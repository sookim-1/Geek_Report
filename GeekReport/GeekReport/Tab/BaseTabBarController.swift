//
//  BaseTabBarController.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit
import RxSwift
import SnapKit

final class BaseTabBarController: UITabBarController, UIConfigurable {

    private let tabBarNavigationManager = TabBarNavigationManager()
    private let customTabBar = CustomTabBar()

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
        let rootView = TempHomeViewController()
        let nextView = HomeNavigationViewController(rootViewController: rootView)
        nextView.delegate = tabBarNavigationManager

        return nextView
    }

    private func createSearchNavigationController() -> UINavigationController {
        let rootView = SearchViewController()
        let nextView = SearchNavigationViewController(rootViewController: rootView)
        nextView.delegate = tabBarNavigationManager

        return nextView
    }

    private func createMyListNavigationController() -> UINavigationController {
        let rootView = MyListViewController()
        let nextView = MyListNavigationViewController(rootViewController: rootView)
        nextView.delegate = tabBarNavigationManager

        return nextView
    }

    private func createSettingNavigationController() -> UINavigationController {
        let rootView = SettingViewController()
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
            $0.height.equalTo(90 + DeviceUI.shared.safeAreaBottomHeight)
        }
    }

    func setupProperties() {
        tabBar.isHidden = true

        customTabBar.addShadow()

        selectedIndex = 0
        setViewControllers([createHomeNavigationController(), createSearchNavigationController(), createMyListNavigationController(), createSettingNavigationController()], animated: true)
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

    func relayTabBarHiiden(hidden: Bool, animated: Bool, duration: TimeInterval) {
        self.setTabBarHidden(hidden, animated: animated, duration: duration)
    }

}

// MARK: - UITabBarControllerDelegate
extension BaseTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarAnimatedTransitioning()
    }

}
