//
//  TopAnimeDataDTO.swift
//  GeekReport
//
//  Created by sookim on 4/11/24.
//

import Foundation

// 상위 애니메이션 목록
struct TopAnimeDataDTO: Codable {
    let data: [AnimeData]

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}
