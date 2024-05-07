//
//  SearchService.swift
//  GeekReport
//
//  Created by sookim on 5/7/24.
//

import Foundation

struct SearchService {

    static let shared = SearchService()

    private let baseURL = "https://api.jikan.moe/v4/"
    private init() {}

    /// 검색목록 애니메이션 API 호출
    func getAnimeSearch(searchString: String, completed: @escaping (Result<[AnimeData], GRError>) -> Void) {
        let endpoint = baseURL + "anime?q=\(searchString)"

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
                let animeLists = try decoder.decode(SearchListDataDTO.self, from: data)

                completed(.success(animeLists.data))
            } catch {
                completed(.failure(.unknownError))
            }

        }

        task.resume()
    }
    
}
