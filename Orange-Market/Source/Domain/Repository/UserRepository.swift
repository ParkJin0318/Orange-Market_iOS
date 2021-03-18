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
}
