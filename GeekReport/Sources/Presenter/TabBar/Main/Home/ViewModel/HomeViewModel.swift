//
//  HomeViewModel.swift
//  GeekReport
//
//  Created by sookim on 6/20/24.
//  Copyright © 2024 sookim-1. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeViewModelInput {
    func didSelectItem(_ animeID: Int)
    func requestGetRecentAnimeRecommendations()
    func requestGetTopAnime()
    func requestGetSpringSeasonAnime()
    func requestGetSummerSeasonAnime()
    func requestGetAutumnSeasonAnime()
    func requestGetWinterSeasonAnime()
    func didCurrentPage(page: Int)
}

protocol HomeViewModelOutput {
    var isLoad: CustomObservable<Bool> { get }

    var animeRecommendationLists: CustomObservable<[DomainAnimeDataModel]> { get }
    var animeTopLists: CustomObservable<[DomainAnimeDataModel]> { get }
    var animeSpringLists: CustomObservable<[DomainAnimeDataModel]> { get }
    var animeSummerLists: CustomObservable<[DomainAnimeDataModel]> { get }
    var animeAutumnLists: CustomObservable<[DomainAnimeDataModel]> { get }
    var animeWinterLists: CustomObservable<[DomainAnimeDataModel]> { get }

    var isCompleteAnimeDetailData: CustomObservable<DomainAnimeDetailDataModel> { get }

    var pagingInfoSubject: PublishSubject<PagingInfo> { get }
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput { }


final class DefaultHomeViewModel: HomeViewModel {

    private let recommendationUseCase = DefaultRecommendationUseCase(recommendationRepository: DefaultRecommendationRepository())
    private let seasonUseCase = DefaultSeasonAnimeUseCase(seasonRepository: DefaultSeasonRepository())
    private let topUseCase = DefaultTopAnimeUseCase(topRepository: DefaultTopRepository())
    private let animUseCase = DefaultAnimeUseCase(animeRepository: DefaultAnimeRepository())
    private let animeRepository = DefaultAnimeRepository()

    var isLoad: CustomObservable<Bool> = CustomObservable(false)
    var animeRecommendationLists: CustomObservable<[DomainAnimeDataModel]> = CustomObservable([])
    var animeTopLists: CustomObservable<[DomainAnimeDataModel]> = CustomObservable([])
    var animeSpringLists: CustomObservable<[DomainAnimeDataModel]> = CustomObservable([])
    var animeSummerLists: CustomObservable<[DomainAnimeDataModel]> = CustomObservable([])
    var animeAutumnLists: CustomObservable<[DomainAnimeDataModel]> = CustomObservable([])
    var animeWinterLists: CustomObservable<[DomainAnimeDataModel]> = CustomObservable([])
    var isCompleteAnimeDetailData: CustomObservable<DomainAnimeDetailDataModel> = CustomObservable(DomainAnimeDetailDataModel.init(animeID: 0, title: "", episodes: 0, imageURLString: "", score: 0.0, rank: 0, favorites: 0, synopsis: "", background: ""))
    var pagingInfoSubject: PublishSubject<PagingInfo> = PublishSubject<PagingInfo>()
    private let itemSelectedSubject = PublishSubject<Int>()

    private let disposeBag = DisposeBag()

    init() {
        itemSelectedSubject
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] animeID -> Observable<DomainAnimeDetailDataModel> in
                guard let self = self else { return Observable.empty() }
                AppLogger.log(tag: .network, "AnimeDetail Data 호출")
                return self.animUseCase.execute(animeID: animeID)
            }
            .withUnretained(self)
            .subscribe(onNext: { owner, data in
                owner.isCompleteAnimeDetailData.value = data
            })
            .disposed(by: disposeBag)
    }

    func didSelectItem(_ animeID: Int) {
        itemSelectedSubject.onNext(animeID)
    }

    func requestGetRecentAnimeRecommendations() {
        AppLogger.log(tag: .network, "최근 데이터 호출")

        recommendationUseCase.execute()
            .withUnretained(self)
            .subscribe { owner, data in
                owner.animeRecommendationLists.value = data.map { $0 }
            }
            .disposed(by: disposeBag)
    }

    func requestGetTopAnime() {
        AppLogger.log(tag: .network, "상위 데이터 호출")

        topUseCase.execute()
            .withUnretained(self)
            .subscribe { owner, data in
                owner.animeTopLists.value = data.map { $0 }
            }
            .disposed(by: disposeBag)
    }

    func requestGetSpringSeasonAnime() {
        AppLogger.log(tag: .network, "1분기 데이터 호출")

        seasonUseCase.execute(season: .spring)
            .withUnretained(self)
            .subscribe { owner, data in
                owner.animeSpringLists.value = data.map { $0 }
            }
            .disposed(by: disposeBag)
    }

    func requestGetSummerSeasonAnime() {
        AppLogger.log(tag: .network, "2분기 데이터 호출")

        seasonUseCase.execute(season: .summer)
            .withUnretained(self)
            .subscribe { owner, data in
                owner.animeSummerLists.value = data.map { $0 }
            }
            .disposed(by: disposeBag)
    }

    func requestGetAutumnSeasonAnime() {
        AppLogger.log(tag: .network, "3분기 데이터 호출")

        seasonUseCase.execute(season: .autumn)
            .withUnretained(self)
            .subscribe { owner, data in
                owner.animeAutumnLists.value = data.map { $0 }
            }
            .disposed(by: disposeBag)
    }

    func requestGetWinterSeasonAnime() {
        AppLogger.log(tag: .network, "4분기 데이터 호출")

        seasonUseCase.execute(season: .winter)
            .withUnretained(self)
            .subscribe { owner, data in
                owner.animeWinterLists.value = data.map { $0 }
                owner.isLoad.value = true
            }
            .disposed(by: disposeBag)
    }

    func didCurrentPage(page: Int) {
        self.pagingInfoSubject.onNext(PagingInfo(currentPage: page))
    }

}
