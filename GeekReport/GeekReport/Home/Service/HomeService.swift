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

    func getTopAnimes(completed: @escaping (Result<AnimeDataList, GRError>) -> Void) {
         let endpoint = baseURL + "top/anime?limit=5"

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
                 let animeLists = try decoder.decode(AnimeDataList.self, from: data)
                 completed(.success(animeLists))
             } catch {
                 completed(.failure(.unknownError))
             }

         }

         task.resume()
     }

}
