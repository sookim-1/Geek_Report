//
//  HomeViewModel.swift
//  GeekReport
//
//  Created by sookim on 6/20/24.
//  Copyright © 2024 sookim-1. All rights reserved.
//

import Foundation

protocol HomeViewModelInput {
}

protocol HomeViewModelOutput {
    
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput { }


final class DefaultHomeViewModel: HomeViewModel {

}
