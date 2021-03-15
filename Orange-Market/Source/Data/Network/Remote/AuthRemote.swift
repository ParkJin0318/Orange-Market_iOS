//
//  AuthRemote.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation
import Moya
import RxSwift

class AuthRemote {
    private lazy var provider: MoyaProvider<AuthAPI> = MoyaProvider()
    
    func login(loginRequest: LoginRequest) -> Single<LoginData> {
        return provider.rx.request(.login(loginRequest: loginRequest))
            .map(Response<LoginData>.self, using: JSONDecoder())
            .map { response -> LoginData in
                return response.data
            }
    }
    
    func register(registerRequest: RegisterRequest) -> Completable {
        return provider.rx.request(.register(registerRequest: registerRequest))
            .asCompletable()
    }
}
