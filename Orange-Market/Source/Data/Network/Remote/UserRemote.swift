//
//  UserRemote.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation
import Moya
import RxSwift

class UserRemote {
    private lazy var provider: MoyaProvider<UserAPI> = MoyaProvider()
    
    func getMyProfile() -> Single<UserData> {
        return provider.rx.request(.getMyProfile)
            .map(Response<UserData>.self, using: JSONDecoder())
            .map { response -> UserData in
                return response.data
            }
    }
}
