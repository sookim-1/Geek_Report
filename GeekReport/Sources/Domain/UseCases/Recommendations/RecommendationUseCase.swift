//
//  RecommendationUseCase.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

protocol RecommendationUseCase {

    func execute() -> Observable<[DomainAnimeDataModel]>
}
