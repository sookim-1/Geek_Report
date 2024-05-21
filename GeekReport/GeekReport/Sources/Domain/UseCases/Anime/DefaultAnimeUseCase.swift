//
//  DefaultAnimeUseCase.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

final class DefaultAnimeUseCase: AnimeDataUseCase {

    private let animeRepository: AnimeRepository

    init(animeRepository: AnimeRepository) {
        self.animeRepository = animeRepository
    }

    func execute(animeID: Int) -> Observable<AnimeDetailData> {
        return animeRepository
            .getAnimeById(animeID: animeID)
    }

    func execute(searchText: String) -> Observable<[AnimeData]> {
        return animeRepository
            .getAnimeSearch(searchText: searchText)
    }

}
