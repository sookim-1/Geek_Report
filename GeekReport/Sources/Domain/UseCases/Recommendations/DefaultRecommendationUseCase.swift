//
//  DefaultRecommendationUseCase.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

final class DefaultRecommendationUseCase: RecommendationUseCase {

    private let recommendationRepository: RecommendationRepository

    init(recommendationRepository: RecommendationRepository) {
        self.recommendationRepository = recommendationRepository
    }

    func execute() -> Observable<[DomainAnimeDataModel]> {
        return self.recommendationRepository
            .getRecentAnimeRecommendations()
    }

}
