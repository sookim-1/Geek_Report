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

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

struct RecommendationAnimeEntry: Codable {
    let entry: [AnimeData]

    enum CodingKeys: String, CodingKey {
        case entry = "entry"
    }
}
