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
        return remote.getUserInfo(idx: idx)
    }
    
    func getUserProfile() -> Single<User> {
        return remote.getUserProfile()
    }
    
    func updateLocation(locationRequest: LocationInfoRequest) -> Single<Void> {
        return remote.updateLocation(locationRequest: locationRequest)
    }
    
    func updateUser(userRequest: UserInfoRequest) -> Single<Void> {
        return remote.updateUser(userRequest: userRequest)
    }
}
