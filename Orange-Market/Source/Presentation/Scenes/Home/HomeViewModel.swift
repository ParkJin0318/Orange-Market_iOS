//
//  HomeViewModel.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        var city = PublishRelay<String>()
    }
    
    lazy var input: Input = Input()
    lazy var output: Output = Output()
    
    lazy var userRepository: UserRepository = UserRepositoryImpl()
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        userRepository.getMyProfile()
            .subscribe { [weak self] data in
                guard let self = self else { return }
                
                self.output.city.accept(data.city)
            } onError: { error in
                self.output.city.accept(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
}
