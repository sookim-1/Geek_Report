//
//  RecommendationRepository.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

protocol RecommendationRepository {

    func getRecentAnimeRecommendations() -> Observable<[AnimeData]>
}
