//
//  File.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/12.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: ViewModelType {
    
    struct Input {
        let idText = PublishSubject<String>()
        let passwordText = PublishSubject<String>()
        let tapLogin = PublishSubject<Void>()
    }
    
    struct Output {
        var isEnabled = PublishRelay<Bool>()
        var isLoading = PublishRelay<Bool>()
        var isLogin = PublishRelay<Bool>()
    }
    
    var input: Input
    var output: Output
    
    var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        self.input = Input()
        self.output = Output()
        
        self.validation()
        self.tapLogin()
    }
    
    private func validation() {
        Observable.combineLatest(input.idText, input.passwordText)
            .map { !$0.0.isEmpty && !$0.1.isEmpty }
            .bind(to: output.isEnabled)
            .disposed(by: disposeBag)
    }
    
    private func tapLogin() {
        input.tapLogin
            .withLatestFrom(Observable.combineLatest(input.idText, input.passwordText))
            .bind { [weak self] (email, password) in
                guard let self = self else { return }
                
                self.output.isLoading.accept(true)
            }.disposed(by: disposeBag)
    }
}
