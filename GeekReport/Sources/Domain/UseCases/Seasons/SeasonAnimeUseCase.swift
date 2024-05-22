//
//  SeasonAnimeUseCase.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

protocol SeasonAnimeUseCase {

    func execute(season: Season) -> Observable<[AnimeData]>
}
