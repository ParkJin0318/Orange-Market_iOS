//
//  UserRepository.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation
import RxSwift

protocol UserRepository {
    func getUserInfo(idx: Int) -> Single<User>
    func getUserProfile() -> Single<User>
    func updateLocation(locationRequest: LocationRequest) -> Single<String>
    func updateUser(userRequest: UserRequest) -> Single<Void>
}
