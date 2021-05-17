//
//  UserDataSource.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/17.
//

import Foundation
import RxSwift

class UserDataSource {
    
    private lazy var remote = UserRemote()
    
    func getUserInfo(idx: Int) -> Single<User> {
        return remote.getUserInfo(idx: idx).map { $0.toModel() }
    }
    
    func getUserProfile() -> Single<User> {
        return remote.getUserProfile().map { $0.toModel() }
    }
    
    func updateLocation(locationRequest: LocationRequest) -> Single<Void> {
        return remote.updateLocation(locationRequest: locationRequest)
    }
    
    func updateUser(userRequest: UserRequest) -> Single<Void> {
        return remote.updateUser(userRequest: userRequest)
    }
}
