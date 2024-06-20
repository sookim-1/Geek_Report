//
//  SettingViewModel.swift
//  GeekReport
//
//  Created by sookim on 6/20/24.
//  Copyright © 2024 sookim-1. All rights reserved.
//

import Foundation

protocol SettingViewModelInput {
    func viewWillAppear()
}

protocol SettingViewModelOutput {
    var isLoad: CustomObservable<Bool> { get }
}

protocol SettingViewModel: SettingViewModelInput, SettingViewModelOutput { }

final class DefaultSettingViewModel: SettingViewModel {

    var isLoad: CustomObservable<Bool> = CustomObservable(false)

    func viewWillAppear() {
        AppLogger.log(tag: .warning, "viewWillAppear")

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isLoad.value = true
        }
    }

}

