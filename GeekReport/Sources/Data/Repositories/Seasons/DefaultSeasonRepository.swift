//
//  DefaultSeasonRepository.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

final class DefaultSeasonRepository: SeasonRepository {

    private let networkService: NetworkService

    init(networkService: NetworkService = DefaultNetworkService()) {
        self.networkService = networkService
    }

    func getSeason(season: Season) -> Observable<[DomainAnimeDataModel]> {
        let endpoint = JikanEndpoint.season(season: season)

        return self.networkService.request(endpoint)
            .decode(type: TargetSeasonDataDTO.self, decoder: JSONDecoder())
            .map { $0.toList() }
    }

}
