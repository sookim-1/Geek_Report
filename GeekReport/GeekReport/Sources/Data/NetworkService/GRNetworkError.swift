//
//  GRNetworkError.swift
//  GeekReport
//
//  Created by sookim on 4/8/24.
//

import Foundation

enum GRNetworkError: LocalizedError {

    case invalidURL
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "올바르지 않은 URL입니다."
        case .unknown:
            return "알 수 없는 오류입니다."
        }
    }

}
