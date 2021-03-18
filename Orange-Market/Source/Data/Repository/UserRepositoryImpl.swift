//
//  UserRepository.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation
import RxSwift

class UserRepositoryImpl: UserRepository {
    private lazy var remote = UserRemote()
    
    func getUserInfo(idx: Int) -> Single<User> {
        return remote.getUserInfo(idx: idx).map { $0.toModel() }
    }
}
