//
//  DefaultSeasonAnimeUseCase.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

final class DefaultSeasonAnimeUseCase: SeasonAnimeUseCase {

    private let seasonRepository: SeasonRepository

    init(seasonRepository: SeasonRepository) {
        self.seasonRepository = seasonRepository
    }

    func execute(season: Season) -> Observable<[DomainAnimeDataModel]> {
        return self.seasonRepository
            .getSeason(season: season)
    }

}
