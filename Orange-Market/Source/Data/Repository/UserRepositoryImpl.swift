//
//  UserRepositoryImpl.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation
import RxSwift

class UserRepositoryImpl: UserRepository {
    
    private lazy var dataSource = UserDataSource()
    
    func getUserInfo(idx: Int) -> Single<User> {
        return dataSource.getUserInfo(idx: idx)
    }
    
    func getUserProfile() -> Single<User> {
        return dataSource.getUserProfile()
    }
    
    func updateLocation(locationRequest: LocationInfoRequest) -> Single<Void> {
        return dataSource.updateLocation(locationRequest: locationRequest)
    }
    
    func updateUser(userRequest: UserInfoRequest) -> Single<Void> {
        return dataSource.updateUser(userRequest: userRequest)
    }
}
