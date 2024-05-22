//
//  RecommendationAnimeDataDTO.swift
//  GeekReport
//
//  Created by sookim on 4/11/24.
//

import Foundation

// 추천 애니메이션 목록
struct RecommendationAnimeDataDTO: Codable {
    let data: [RecommendationAnimeEntry]

}

struct RecommendationAnimeEntry: Codable {
    var entry: [AnimeData]


    func toList() -> [DomainAnimeDataModel] {
        return entry.map {
            DomainAnimeDataModel(animeID: $0.animeID,
                                 title: $0.title,
                                 episodes: $0.episodes,
                                 imageURLString: $0.imageURLs.jpgURLs.largeImageURL)
        }
    }
}
