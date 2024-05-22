//
//  AnimeDataModel.swift
//  GeekReport
//
//  Created by sookim on 4/8/24.
//

import Foundation

struct DomainAnimeDataModel {

    let uuid = UUID()
    let animeID: Int
    let title: String
    let episodes: Int?
    let imageURLString: String

}

extension DomainAnimeDataModel: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    static func == (lhs: DomainAnimeDataModel, rhs: DomainAnimeDataModel) -> Bool {
        return lhs.uuid == rhs.uuid
    }

}


struct DomainAnimeDetailDataModel {

    let animeID: Int
    let title: String
    let episodes: Int?
    let imageURLString: String
    let score: Double
    let rank: Int?
    let favorites: Int
    let synopsis: String
    let background: String?

}
