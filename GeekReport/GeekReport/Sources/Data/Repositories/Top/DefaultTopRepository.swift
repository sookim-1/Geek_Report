//
//  DefaultTopRepository.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

final class DefaultTopRepository: TopRepository {

    private let networkService: NetworkService

    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }

    func getTopAnime() -> Observable<[AnimeData]> {
        let endpoint = JikanEndpoint.topAnime

        return self.networkService.request(endpoint)
            .decode(type: TopAnimeDataDTO.self, decoder: JSONDecoder())
            .map { $0.data }
    }

}
