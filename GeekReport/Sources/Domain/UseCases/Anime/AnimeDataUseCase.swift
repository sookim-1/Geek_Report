//
//  AnimeDataUseCase.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

protocol AnimeDataUseCase {

    func execute(animeID: Int) -> Observable<DomainAnimeDetailDataModel>
    func execute(searchText: String) -> Observable<[DomainAnimeDataModel]>
}

final class DefaultAnimeUseCase: AnimeDataUseCase {

    private let animeRepository: AnimeRepository

    init(animeRepository: AnimeRepository) {
        self.animeRepository = animeRepository
    }

    func execute(animeID: Int) -> Observable<DomainAnimeDetailDataModel> {
        return animeRepository
            .getAnimeById(animeID: animeID)
    }

    func execute(searchText: String) -> Observable<[DomainAnimeDataModel]> {
        return animeRepository
            .getAnimeSearch(searchText: searchText)
    }

}
