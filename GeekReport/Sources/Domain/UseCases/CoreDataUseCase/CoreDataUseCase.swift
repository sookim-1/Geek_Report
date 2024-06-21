//
//  CoreDataUseCase.swift
//  GeekReport
//
//  Created by sookim on 6/21/24.
//  Copyright © 2024 sookim-1. All rights reserved.
//

import Foundation
import RxSwift

protocol CoreDataUseCase {

    func executeCreate(selectEpisode: Int, item: DomainAnimeDetailDataModel) -> Observable<Bool>
    func executeFetch() -> Observable<[DomainAnimeDataModel]>
    func executeUpdate(selectEpisode: Int, item: DomainAnimeDetailDataModel) -> Observable<Bool>
}

final class DefaultCoreDataUseCase: CoreDataUseCase {
    func executeCreate(selectEpisode: Int, item: DomainAnimeDetailDataModel) -> Observable<Bool> {
        let result = CoreDataStorage.shared.saveData(selectEpisode: selectEpisode, item: item)

        return Observable.just(result)
    }
    
    func executeFetch() -> Observable<[DomainAnimeDataModel]> {
        let result = CoreDataStorage.shared.fetchData()

        return Observable.just(result)
    }

    func executeUpdate(selectEpisode: Int, item: DomainAnimeDetailDataModel) -> Observable<Bool> {
        let result = CoreDataStorage.shared.updateData(selectEpisode: selectEpisode, item: item)

        return Observable.just(result)
    }

}
