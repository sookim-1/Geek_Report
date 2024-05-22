//
//  DefaultRecommendationRepository.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

final class DefaultRecommendationRepository: RecommendationRepository {

    private let networkService: NetworkService

    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }
    
    func getRecentAnimeRecommendations() -> Observable<[DomainAnimeDataModel]> {
        let endpoint = JikanEndpoint.recentAnimeRecommendation

        return self.networkService.request(endpoint)
            .decode(type: RecommendationAnimeDataDTO.self, decoder: JSONDecoder())
            .map { $0.data.flatMap { $0.entry } }
            .map { Array($0.prefix(5)) }
            .map { animeDataArray in
                animeDataArray.map { animeData in
                    DomainAnimeDataModel(
                        animeID: animeData.animeID,
                        title: animeData.title,
                        episodes: animeData.episodes,
                        imageURLString: animeData.imageURLs.jpgURLs.largeImageURL
                    )
                }
            }
    }
    

}
