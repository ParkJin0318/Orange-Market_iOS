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
    
    lazy var input: Input = Input()
    lazy var output: Output = Output()
    
    lazy var authRepository: AuthRepository = AuthRepositoryImpl()
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    
    init() {
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
                self.login(email: email, password: password)
            }.disposed(by: disposeBag)
    }
    
    private func login(email: String, password: String) {
        let loginRequest = LoginRequest(userId: email, userPw: password)
        
        authRepository.login(loginRequest: loginRequest)
            .subscribe { [weak self] data in
                guard let self = self else { return }
                
                AuthController.getInstance().login(token: data.accessToken)
                self.output.isLogin.accept(true)
                self.output.isLoading.accept(false)
            } onError: { [weak self] error in
                guard let self = self else { return }
                
                self.output.isLogin.accept(false)
                self.output.isLoading.accept(false)
            }.disposed(by: disposeBag)
    }
}
