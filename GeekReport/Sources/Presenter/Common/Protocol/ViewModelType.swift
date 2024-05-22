//
//  ViewModelType.swift
//  GeekReport
//
//  Created by sookim on 5/21/24.
//

import Foundation
import RxSwift

protocol ViewModelType: AnyObject {

    associatedtype Input
    associatedtype Output

    var disposeBag: DisposeBag { get }
    func transform(input: Input) -> Output

}
