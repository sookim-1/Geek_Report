//
//  DefaultTopAnimeUseCase.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

final class DefaultTopAnimeUseCase: TopAnimeUseCase {

    private let topRepository: TopRepository

    init(topRepository: TopRepository) {
        self.topRepository = topRepository
    }

    func execute() -> Observable<[AnimeData]> {
        return self.topRepository
            .getTopAnime()
    }

}
