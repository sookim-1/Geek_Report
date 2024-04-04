//
//  BaseTabBarController.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit

final class BaseTabBarController: UITabBarController {
    
    private let tabBarNavigationManager = TabBarNavigationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        configureTabbar()
        viewControllers = [createHomeNavigationController(), createSearchNavigationController(), createMyListNavigationController(), createSettingNavigationController()]
    }

    private func configureTabbar() {
        tabBar.tintColor = .systemGray6
        tabBar.unselectedItemTintColor = .systemGray4
        tabBar.backgroundColor = .white
        tabBar.barTintColor = .white
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.systemGray2.cgColor
        tabBar.clipsToBounds = true
    }

    private func createHomeNavigationController() -> UINavigationController {
        let rootView = HomeViewController()
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
