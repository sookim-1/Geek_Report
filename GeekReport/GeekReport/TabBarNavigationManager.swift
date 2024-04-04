//
//  TabBarNavigationManager.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit

protocol TabBarNavigationManagerDelegate: AnyObject {
    func relayTabBarHiiden(hidden: Bool, animated: Bool, duration: TimeInterval)
}

final class TabBarNavigationManager: NSObject, UINavigationControllerDelegate {

    weak var delegate: TabBarNavigationManagerDelegate?

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

        print("navigationController: \(navigationController)\nviewController: \(viewController)")

        switch navigationController {
        case is HomeNavigationViewController:
            print("navigationController: \(navigationController)\nviewController: \(viewController)")
        case is SearchNavigationViewController:
            print("navigationController: \(navigationController)\nviewController: \(viewController)")
        case is MyListNavigationViewController:
            print("navigationController: \(navigationController)\nviewController: \(viewController)")
        case is SettingNavigationViewController:
            print("navigationController: \(navigationController)\nviewController: \(viewController)")
        default:
            print("navigationController: \(navigationController)\nviewController: \(viewController)")
        }
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("navigationController: \(navigationController)\nviewController: \(viewController)")
    }


}
