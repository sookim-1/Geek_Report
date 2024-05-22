//
//  NetworkService.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

protocol NetworkService {

    func request(_ endpoint: Endpoint) -> Observable<Data>

}
