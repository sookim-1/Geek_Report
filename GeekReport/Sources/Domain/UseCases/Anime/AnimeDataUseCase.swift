//
//  AnimeDataUseCase.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

protocol AnimeDataUseCase {

    func execute(animeID: Int) -> Observable<AnimeDetailData>
    func execute(searchText: String) -> Observable<[AnimeData]>
}
