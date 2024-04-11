//
//  AnimeDataModel.swift
//  GeekReport
//
//  Created by sookim on 4/8/24.
//

import Foundation

// MARK: - AnimeData
struct AnimeData: Codable {
    let animeID: Int
    let title: String
    let imageURLs: ImageURLs

    enum CodingKeys: String, CodingKey {
        case animeID = "mal_id"
        case imageURLs = "images"
        case title
    }
}

// MARK: - ImageURLs
struct ImageURLs: Codable {
    let jpgURLs: JpgURLs

    enum CodingKeys: String, CodingKey {
        case jpgURLs = "jpg"
    }
}

// MARK: - JpgURLs
struct JpgURLs: Codable {
    let basicImageURL: String
    let smallImageURL: String
    let largeImageURL: String

    enum CodingKeys: String, CodingKey {
        case basicImageURL = "image_url"
        case smallImageURL = "small_image_url"
        case largeImageURL = "large_image_url"
    }
}
