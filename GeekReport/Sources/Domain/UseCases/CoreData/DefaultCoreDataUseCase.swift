//
//  DefaultCoreDataUseCase.swift
//  GeekReport
//
//  Created by sookim on 5/22/24.
//  Copyright © 2024 sookim-1. All rights reserved.
//

import Foundation
import RxSwift

final class DefaultCoreDataUseCase: CoreDataUseCase {

    private let coreDataRepository: CoreDataRepository

    init(coreDataRepository: CoreDataRepository) {
        self.coreDataRepository = coreDataRepository
    }

    func getAnimes() -> [DomainAnimeDataModel] {
        return coreDataRepository
            .getAnimes()
    }

    func getAnime(id: UUID) -> Observable<DomainAnimeDataModel> {
        return coreDataRepository
            .getAnime(id: id)
    }

    func deleteAnime(_ id: UUID) -> Observable<Bool> {
        return coreDataRepository
            .deleteAnime(id)
    }

    func createAnime(selectEpisode: Int, _ model: DomainAnimeDataModel) -> Observable<Bool> {
        return coreDataRepository
            .createAnime(selectEpisode: selectEpisode, model)
    }

    func updateAnime(_ id: UUID, _ model: DomainAnimeDataModel) -> Observable<Bool> {
        return coreDataRepository
            .updateAnime(id, model)
    }

}
