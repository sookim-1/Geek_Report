//
//  TopAnimeUseCase.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

protocol TopAnimeUseCase {

    func execute() -> Observable<[AnimeData]>
}
