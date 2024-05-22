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
        var myAnimeList: Driver<[AnimeEntities]>
        let selectAnimeDone: Observable<AnimeDetailData>
    }

    private let animUseCase: AnimeDataUseCase

    private var container: NSPersistentContainer
    let disposeBag = DisposeBag()

    init(animUseCase: AnimeDataUseCase, 
         container: NSPersistentContainer) {
        self.animUseCase = animUseCase
        self.container = container
    }

    func transform(input: Input) -> Output {
        let myAnimeList = input.viewWillappear
            .withUnretained(self)
            .map { owner, _ in
                try owner.container.viewContext.fetch(AnimeEntities.fetchRequest())
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
