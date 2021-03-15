//
//  ViewModelType.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/12.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get set }
    var output: Output { get set }
    
    var disposeBag: DisposeBag { get set }
}
