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
    
    func login(loginRequest: LoginRequest) -> Single<String> {
        return provider.rx.request(.login(loginRequest: loginRequest))
            .map(Response<String>.self, using: JSONDecoder())
            .map { response -> String in
                return response.data
            }
    }
    
    func register(registerRequest: RegisterRequest) -> Single<Void> {
        return provider.rx.request(.register(registerRequest: registerRequest))
            .map(MessageResponse.self, using: JSONDecoder())
            .map { response -> Void in
                return Void()
            }
    }
}
