//
//  SearchViewModel.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift

final class SearchViewModel: ViewModelType {

    struct Input {
        let searchAnime: Observable<String>
        let selectAnime: Observable<Int>
    }

    struct Output {
        var searchList: Observable<[AnimeData]>
        let selectAnimeDone: Observable<AnimeDetailData>
    }

    private let animUseCase: AnimeDataUseCase

    let disposeBag = DisposeBag()

    init(animUseCase: AnimeDataUseCase) {
        self.animUseCase = animUseCase
    }

    func transform(input: Input) -> Output {
        let searchAnimeList = input.searchAnime
            .withUnretained(self)
            .flatMap { owner, text in
                owner.animUseCase.execute(searchText: text)
            }

        let selectAnimeDone = input.selectAnime
            .withUnretained(self)
            .flatMap { owner, id in
                owner.animUseCase.execute(animeID: id)
            }

        return Output(searchList: searchAnimeList, selectAnimeDone: selectAnimeDone)
    }

}
