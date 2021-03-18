//
//  LoginRepository.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation
import RxSwift

protocol AuthRepository {
    func login(loginRequest: LoginRequest) -> Single<String>
    func register(registerRequest: RegisterRequest) -> Completable
    func getUserProfile() -> Single<User>
}
