//
//  SearchListDataDTO.swift
//  GeekReport
//
//  Created by sookim on 5/7/24.
//

import Foundation

// 검색 애니메이션 목록
struct SearchListDataDTO: Codable {
    let data: [AnimeData]

    func toList() -> [DomainAnimeDataModel] {
        return data.map {
            DomainAnimeDataModel(animeID: $0.animeID,
                                 title: $0.title,
                                 episodes: $0.episodes,
                                 imageURLString: $0.imageURLs.jpgURLs.largeImageURL)
        }
    }

}
