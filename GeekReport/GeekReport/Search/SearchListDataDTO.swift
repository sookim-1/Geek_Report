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

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}
