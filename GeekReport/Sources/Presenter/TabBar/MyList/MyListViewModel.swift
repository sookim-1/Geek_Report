//
//  MyListViewModel.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import CoreData
import RxCocoa
import RxRelay
import RxSwift

final class MyListViewModel: ViewModelType {

    struct Input {
        let viewWillappear: Observable<Void>
        let selectAnime: Observable<Int>
    }

    struct Output {
        var myAnimeList: Driver<[DomainAnimeDataModel]>
        let selectAnimeDone: Observable<DomainAnimeDetailDataModel>
    }

    private let animUseCase: AnimeDataUseCase
    private let coreDataUseCase: CoreDataUseCase
    let disposeBag = DisposeBag()

    init(animUseCase: AnimeDataUseCase, 
         coreDataUseCase: CoreDataUseCase) {
        self.animUseCase = animUseCase
        self.coreDataUseCase = coreDataUseCase
    }

    func transform(input: Input) -> Output {
        let myAnimeList = input.viewWillappear
            .withUnretained(self)
            .map { owner, _ in
                self.coreDataUseCase.getAnimes()
            }
            .asDriver(onErrorJustReturn: [])

        let selectAnimeDone = input.selectAnime
            .withUnretained(self)
            .flatMap { owner, id in
                owner.animUseCase.execute(animeID: id)
            }

        return Output(myAnimeList: myAnimeList, selectAnimeDone: selectAnimeDone)
    }

}
