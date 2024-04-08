//
//  AnimeDataModel.swift
//  GeekReport
//
//  Created by sookim on 4/8/24.
//

import Foundation

// MARK: - AnimeDataList
struct AnimeDataList: Codable {
    let dataLists: [AnimeData]

    enum CodingKeys: String, CodingKey {
        case dataLists = "data"
    }
}

// MARK: - Datum
struct AnimeData: Codable {
    let animeID: Int
    let title: String
    let images: AnimeDataImage

    enum CodingKeys: String, CodingKey {
        case animeID = "mal_id"
        case images, title
    }
}

// MARK: - Images
struct AnimeDataImage: Codable {
    let jpgURLs: JpgURLs

    enum CodingKeys: String, CodingKey {
        case jpgURLs = "jpg"
    }
}

// MARK: - JpgURLs
struct JpgURLs: Codable {
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
    }
}
