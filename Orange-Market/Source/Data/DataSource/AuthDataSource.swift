//
//  AuthDataSource.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/17.
//

import Foundation
import RxSwift

class AuthDataSource {
    
    private lazy var remote = AuthRemote()
    
    func login(loginRequest: LoginRequest) -> Single<Void> {
        return remote.login(loginRequest: loginRequest)
            .flatMap { token in
                AuthController.getInstance().login(token: token)
                return .just(Void())
            }
    }
    
    func register(registerRequest: RegisterRequest) -> Single<Void> {
        return remote.register(registerRequest: registerRequest)
    }
}
