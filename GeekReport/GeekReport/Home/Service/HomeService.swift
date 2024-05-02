//
//  HomeService.swift
//  GeekReport
//
//  Created by sookim on 4/8/24.
//

import Foundation

struct HomeService {

    static let shared = HomeService()

    private let baseURL = "https://api.jikan.moe/v4/"
    private init() {}

    /// 추천목록 애니메이션 API 호출
    func getRecentAnimeRecommendations(completed: @escaping (Result<[AnimeData], GRError>) -> Void) {
        let endpoint = baseURL + "recommendations/anime?page=1"

        guard let url = URL(string: endpoint) else {
            completed(.failure(.unknownError))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let _ = error {
                completed(.failure(.unknownError))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200
            else {
                completed(.failure(.unknownError))
                return
            }

            guard let data
            else {
                completed(.failure(.unknownError))
                return
            }

            do {
                let decoder = JSONDecoder()
                let animeLists = try decoder.decode(RecommendationAnimeDataDTO.self, from: data)

                var entryLists: [AnimeData] = []
                animeLists.data.forEach {
                    entryLists.append(contentsOf: $0.entry)
                }

                var shuffleEntryLists = entryLists.shuffled() 
                shuffleEntryLists.removeSubrange(5..<shuffleEntryLists.count)

                completed(.success(shuffleEntryLists))
            } catch {
                completed(.failure(.unknownError))
            }

        }

        task.resume()
    }

    /// Top 애니메이션 API 호출
    func getTopAnime(completed: @escaping (Result<[AnimeData], GRError>) -> Void) {
        let endpoint = baseURL + "top/anime?limit=10"

        guard let url = URL(string: endpoint) else {
            completed(.failure(.unknownError))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let _ = error {
                completed(.failure(.unknownError))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200
            else {
                completed(.failure(.unknownError))
                return
            }

            guard let data
            else {
                completed(.failure(.unknownError))
                return
            }

            do {
                let decoder = JSONDecoder()
                let animeLists = try decoder.decode(TopAnimeDataDTO.self, from: data)

                completed(.success(animeLists.data))
            } catch {
                completed(.failure(.unknownError))
            }

        }

        task.resume()
    }

}
