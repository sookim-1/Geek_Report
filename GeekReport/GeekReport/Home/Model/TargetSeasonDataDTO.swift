//
//  TargetSeasonDataDTO.swift
//  GeekReport
//
//  Created by sookim on 4/11/24.
//

import Foundation

// 추후 시즌 애니메이션 목록
struct TargetSeasonDataDTO: Codable {
    let data: [AnimeData]

    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}
