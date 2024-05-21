//
//  MoreAnimeViewModel.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MoreAnimeViewModel: ViewModelType {

    struct Input {
        let selectAnime: Observable<Int>
    }

    struct Output {
        var moreAnimeList: Observable<[DomainAnimeDataModel]>
        let selectAnimeDone: Observable<AnimeDetailData>
    }

    private let animUseCase: AnimeDataUseCase
    private let animeLists: [DomainAnimeDataModel]
    let disposeBag = DisposeBag()

    init(animUseCase: AnimeDataUseCase,
         animeLists: [DomainAnimeDataModel]) {
        self.animUseCase = animUseCase
        self.animeLists = animeLists
    }

    func transform(input: Input) -> Output {
        let animeLists = Observable.just(self.animeLists)

        let selectAnimeDone = input.selectAnime
            .withUnretained(self)
            .flatMap { owner, id in
                owner.animUseCase.execute(animeID: id)
            }

        return Output(moreAnimeList: animeLists, selectAnimeDone: selectAnimeDone)
    }

}
