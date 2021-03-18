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
    
    func login(loginRequest: LoginRequest) -> Single<String> {
        return remote.login(loginRequest: loginRequest).map { $0.accessToken }
    }
    
    func register(registerRequest: RegisterRequest) -> Completable {
        return remote.register(registerRequest: registerRequest)
    }
    
    func getUserProfile() -> Single<User> {
        return remote.getUserProfile().map { $0.toModel() }
    }
}
