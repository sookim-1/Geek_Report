//
//  SeasonRepository.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

protocol SeasonRepository {

    func getSeason(season: Season) -> Observable<[AnimeData]>
}
