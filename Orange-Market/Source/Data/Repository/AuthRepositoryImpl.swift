//
//  LoginRepository.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation
import RxSwift

class AuthRepositoryImpl: AuthRepository {
    
    private lazy var remote = AuthRemote()
    
    func login(loginRequest: LoginRequest) -> Single<Void> {
        return remote.login(loginRequest: loginRequest)
            .flatMap { token -> Single<Void> in
                AuthController.getInstance().login(token: token)
                return .just(Void())
            }
    }
    
    func register(registerRequest: RegisterRequest) -> Completable {
        return remote.register(registerRequest: registerRequest).asCompletable()
    }
}
