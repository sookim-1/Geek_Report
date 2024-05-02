//
//  ListItem.swift
//  GeekReport
//
//  Created by sookim on 4/26/24.
//

import Foundation

struct ListItem: Hashable {
    let id = UUID()
    let title: String

    init(title: String) {
        self.title = title
    }

}

extension ListItem {
    static var defaultData: [Self] {
        return [
            ListItem(title: "Chapter 1"),
            ListItem(title: "Chapter 2"),
            ListItem(title: "Chapter 3"),
            ListItem(title: "Chapter 4"),
            ListItem(title: "Chapter 5"),
            ListItem(title: "Chapter 6"),
            ListItem(title: "Chapter 7"),
            ListItem(title: "Chapter 8"),
            ListItem(title: "Chapter 9"),
            ListItem(title: "Chapter 10"),
            ListItem(title: "Chapter 11"),
            ListItem(title: "Chapter 12"),
            ListItem(title: "Chapter 13"),
            ListItem(title: "Chapter 14"),
            ListItem(title: "Chapter 15"),
            ListItem(title: "Chapter 16"),
            ListItem(title: "Chapter 17"),
            ListItem(title: "Chapter 18"),
            ListItem(title: "Chapter 19"),
            ListItem(title: "Chapter 20"),
            ListItem(title: "Chapter 21"),
            ListItem(title: "Chapter 22"),
            ListItem(title: "Chapter 23"),
            ListItem(title: "Chapter 24")
        ]
    }
}
