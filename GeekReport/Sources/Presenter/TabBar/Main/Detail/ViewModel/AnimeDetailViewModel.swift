//
//  AnimeDetailViewModel.swift
//  GeekReport
//
//  Created by sookim on 6/20/24.
//  Copyright © 2024 sookim-1. All rights reserved.
//

import Foundation

protocol AnimeDetailViewModelInput {
    func goBack()
    func didTapSegment(index: Int)
    func didSaveAnimationData()
    func selectAnimationEpisode(index: Int)
}

protocol AnimeDetailViewModelOutput {
    var episodes: [Int] { get }
    var title: String { get }
    var imagePathURL: URL? { get }
    var rankString: String { get }
    var scoreString: String { get }
    var favouriteString: String { get }
    var selectEpisode: CustomObservable<Int> { get }
    var descriptionString: CustomObservable<String> { get }
}

protocol AnimeDetailViewModel: AnimeDetailViewModelInput, AnimeDetailViewModelOutput { }

final class DefaultAnimeDetailViewModel: AnimeDetailViewModel {

    private var item: DomainAnimeDetailDataModel!
    private var coreDataUseCase = DefaultCoreDataUseCase(coreDataRepository: DefaultCoreDataRepository())

    // MARK: - OUTPUT
    let title: String
    let imagePathURL: URL?
    let rankString: String
    let scoreString: String
    let favouriteString: String
    let episodes: [Int]
    var selectEpisode: CustomObservable<Int> = CustomObservable(1)
    var descriptionString: CustomObservable<String> = CustomObservable("")

    init(item: DomainAnimeDetailDataModel) {
        self.item = item

        self.title = item.title
        self.imagePathURL = URL(string: item.imageURLString)

        if let rankNumber = item.rank {
            self.rankString = "\(rankNumber)"
        } else {
            AppLogger.log(tag: .debug, "Rank = nil")
            self.rankString = "미정"
        }

        self.scoreString = "\(item.score)"
        self.favouriteString = "\(item.favorites.formatThousandString)"

        if let itemEpisodes = item.episodes,
                itemEpisodes > 0 {
            self.episodes = Array(1...itemEpisodes)
        } else {
            self.episodes = []
        }

        self.descriptionString.value = self.item.synopsis
    }

    func selectAnimationEpisode(index: Int) {
        selectEpisode.value = self.episodes[index]
    }


    func goBack() {

    }

    func didSaveAnimationData() {
        AppLogger.log(tag: .network, "CoreData 저장 시작")
    }

    func didTapSegment(index: Int) {
        self.descriptionString.value = (index == 0) ? self.item.synopsis : (self.item.background ?? "")
    }

}

