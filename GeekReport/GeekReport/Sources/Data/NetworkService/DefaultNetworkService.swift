//
//  DefaultNetworkService.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

final class DefaultNetworkService: NetworkService {

    private let session: URLSession = .shared

    func request(_ endpoint: Endpoint) -> Observable<Data> {
        guard let urlRequest = endpoint.toURLRequest() else { return .error(GRNetworkError.invalidURL) }

        return URLSession.shared.rx
            .data(request: urlRequest)
            .asObservable()
    }
    
}
