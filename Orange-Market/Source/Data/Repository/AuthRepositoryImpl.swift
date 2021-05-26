//
//  AuthRepositoryImpl.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation
import RxSwift

class AuthRepositoryImpl: AuthRepository {
    
    private lazy var dataSource = AuthDataSource()
    
    func login(loginRequest: LoginRequest) -> Single<Void> {
        return dataSource.login(loginRequest: loginRequest)
    }
    
    func register(registerRequest: RegisterRequest) -> Single<Void> {
        return dataSource.register(registerRequest: registerRequest)
    }
}
