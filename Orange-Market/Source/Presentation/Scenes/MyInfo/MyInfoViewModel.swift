//
//  MyInfoViewModel.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/23.
//

import Foundation
import RxSwift
import RxCocoa

class MyInfoViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        let userData = PublishRelay<User>()
    }
    
    lazy var input: Input = Input()
    lazy var output: Output = Output()
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var authRepository: AuthRepository = AuthRepositoryImpl()
    
    init() {
        authRepository.getUserProfile()
            .subscribe { [weak self] user in
                self?.output.userData.accept(user)
            } onFailure: { error in
                print(error)
            }.disposed(by: disposeBag)
    }
}
