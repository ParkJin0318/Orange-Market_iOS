//
//  UserRemote.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/18.
//

import Moya
import RxSwift

class UserRemote {
    private lazy var provider: MoyaProvider<UserAPI> = MoyaProvider()
    
    func getUserInfo(idx: Int) -> Single<UserData> {
        return provider.rx.request(.getUserInfo(idx: idx))
            .map(Response<UserData>.self, using: JSONDecoder())
            .map { response -> UserData in
                return response.data
            }
    }
}
