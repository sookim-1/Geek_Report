//
//  TabBarNavigationManager.swift
//  GeekReport
//
//  Created by sookim on 4/4/24.
//

import UIKit

protocol TabBarNavigationManagerDelegate: AnyObject {
    func customTabbarHidden(hidden: Bool)
}

final class TabBarNavigationManager: NSObject, UINavigationControllerDelegate {

    weak var delegate: TabBarNavigationManagerDelegate?

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

        print("navigationController: \(navigationController)\nviewController: \(viewController)")
        
        viewController.navigationController?.isNavigationBarHidden = true
        delegate?.customTabbarHidden(hidden: false)

        switch navigationController {
        case is HomeNavigationViewController:
            switch viewController {
            case is HomeViewController:
                viewController.navigationController?.isNavigationBarHidden = true
            case is AnimeDetailViewController:
                viewController.navigationController?.isNavigationBarHidden = true
                delegate?.customTabbarHidden(hidden: true)
            case is MoreAnimeViewController:
                viewController.navigationController?.isNavigationBarHidden = true
                delegate?.customTabbarHidden(hidden: true)
            default:
                print("navigationController: \(navigationController)\nviewController: \(viewController)")
            }

            print("navigationController: \(navigationController)\nviewController: \(viewController)")
        case is SearchNavigationViewController:
            switch viewController {
            case is SearchViewController:
                viewController.navigationController?.isNavigationBarHidden = false
            default:
                print("navigationController: \(navigationController)\nviewController: \(viewController)")
            }
            
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
