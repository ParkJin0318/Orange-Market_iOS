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
    
    func getUserProfile() -> Single<User> {
        return remote.getUserProfile().map { $0.toModel() }
    }
    
    func updateLocation(locationRequest: LocationRequest) -> Single<String> {
        return remote.updateLocation(locationRequest: locationRequest)
    }
    
    func updateUser(userRequest: UserRequest) -> Single<Void> {
        return remote.updateUser(userRequest: userRequest)
            .flatMap { _ in
                .just(Void())
            }
    }
}
