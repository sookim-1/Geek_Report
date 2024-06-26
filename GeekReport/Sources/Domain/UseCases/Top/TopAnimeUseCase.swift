//
//  TopAnimeUseCase.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

protocol TopAnimeUseCase {
    func execute() -> Observable<[DomainAnimeDataModel]>
}

final class DefaultTopAnimeUseCase: TopAnimeUseCase {

    private let topRepository: TopRepository

    init(topRepository: TopRepository) {
        self.topRepository = topRepository
    }

    func execute() -> Observable<[DomainAnimeDataModel]> {
        return self.topRepository
            .getTopAnime()
    }

}
