//
//  ViewControllerType.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/24.
//

import AsyncDisplayKit
import RxSwift

protocol ViewControllerType {
    
    var disposeBag: DisposeBag { get set }
    
    func setupNode() -> Void
    func setupNavigationBar() -> Void
    func bind() -> Void
}
