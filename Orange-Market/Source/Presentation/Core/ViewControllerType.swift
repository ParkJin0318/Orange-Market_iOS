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
    
    /*
     init 호출 후 Node 설정
     */
    func initNode() -> Void
    /*
     ViewDidLoad 호출 후 Node 설정
     */
    func loadNode() -> Void
    
    func setupNavigationBar() -> Void
    func bind() -> Void
}
