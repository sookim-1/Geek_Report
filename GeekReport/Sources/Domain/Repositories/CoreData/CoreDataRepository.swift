//
//  CoreDataRepository.swift
//  GeekReport
//
//  Created by sookim on 5/22/24.
//  Copyright © 2024 sookim-1. All rights reserved.
//

import Foundation
import RxSwift

protocol CoreDataRepository {

    func getAnimes() -> [DomainAnimeDataModel]
    func getAnime(id: UUID) -> Observable<DomainAnimeDataModel>
    func deleteAnime(_ id: UUID) -> Observable<Bool>
    func createAnime(selectEpisode: Int, _ model: DomainAnimeDataModel) -> Observable<Bool>
    func updateAnime(_ id: UUID, _ model: DomainAnimeDataModel) -> Observable<Bool>
}
