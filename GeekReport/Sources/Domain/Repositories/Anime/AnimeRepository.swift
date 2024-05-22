//
//  AnimeRepository.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

protocol AnimeRepository {

    func getAnimeById(animeID: Int) -> Observable<DomainAnimeDetailDataModel>
    func getAnimeSearch(searchText: String) -> Observable<[DomainAnimeDataModel]>
}
