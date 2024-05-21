//
//  JikanEndpoint.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation

enum JikanEndpoint: Endpoint {
    
    case topAnime
    case recentAnimeRecommendation
    case animeById(animeID: Int)
    case animeSearch(searchText: String)
    case season(season: Season)

    var baseURL: URL? { return URL(string: "https://api.jikan.moe/v4/") }
    var method: HTTPMethod { return .GET }

    var path: String {
        switch self {
        case .topAnime:
            return "top/anime"
        case .recentAnimeRecommendation:
            return "recommendations/anime"
        case .animeById(let animeID):
            return "anime/\(animeID)"
        case .animeSearch(_):
            return "anime"
        case .season(let season):
            return "seasons/\(GlobalDateFormmater.shared.currentYear)/\(season.rawValue)"
        }
    }

    var parameters: HTTPRequestParameter? {
        switch self {
        case .topAnime:
            return .query(["limit": "10"])
        case .recentAnimeRecommendation:
            return .query(["page": "1"])
        case .animeById(_):
            return .none
        case .animeSearch(_):
            return .none
        case .season(_):
            return .query(["limit": "10"])
        }
    }

}
