//
//  DefaultAnimeRepository.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

final class DefaultAnimeRepository: AnimeRepository {

    private let networkService: NetworkService

    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }

    func getAnimeById(animeID: Int) -> Observable<AnimeDetailData> {
        let endpoint = JikanEndpoint.animeById(animeID: animeID)

        return self.networkService.request(endpoint)
            .decode(type: AnimeDetailDataDTO.self, decoder: JSONDecoder())
            .map { $0.data }
    }
    
    func getAnimeSearch(searchText: String) -> Observable<[AnimeData]> {
        let endpoint = JikanEndpoint.animeSearch(searchText: searchText)

        return self.networkService.request(endpoint)
            .decode(type: SearchListDataDTO.self, decoder: JSONDecoder())
            .map { $0.data }
    }
    


}
