//
//  CustomTabItem.swift
//  GeekReport
//
//  Created by sookim on 4/5/24.
//

import UIKit

enum CustomTabItem: String, CaseIterable {
    case home
    case search
    case mylist
    case setting
}

extension CustomTabItem {

    var icon: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        case .search:
            return UIImage(systemName: "magnifyingglass.circle")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        case .mylist:
            return UIImage(systemName: "list.bullet.rectangle")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        case .setting:
            return UIImage(systemName: "gearshape")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        }
    }

    var selectedIcon: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "house.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        case .search:
            return UIImage(systemName: "magnifyingglass.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        case .mylist:
            return UIImage(systemName: "list.bullet.rectangle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        case .setting:
            return UIImage(systemName: "gearshape.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        }
    }

    var name: String {
        switch self {
        case .home:
            return "홈"
        case .search:
            return "검색"
        case .mylist:
            return "나의 목록"
        case .setting:
            return "설정"
        }
    }

}
