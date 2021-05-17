//
//  TownLifeRemote.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/13.
//

import Foundation
import RxSwift
import Moya

class TownLifeRemote {
    private lazy var provider: MoyaProvider<TownLifeAPI> = MoyaProvider()
    
    func getAllTownLife(city: String) -> Single<Array<TownLifeData>> {
        return provider.rx.request(.getAllTownLife(city: city))
            .map(Response<Array<TownLifeData>>.self, using: JSONDecoder())
            .map { response -> Array<TownLifeData> in
                return response.data
            }
    }
    
    func getTownLife(idx: Int) -> Single<TownLifeData> {
        return provider.rx.request(.getTownLife(idx: idx))
            .map(Response<TownLifeData>.self, using: JSONDecoder())
            .map { response -> TownLifeData in
                return response.data
            }
    }
    
    func getAllComment(idx: Int) -> Single<Array<TownLifeCommentData>> {
        return provider.rx.request(.getAllComment(idx: idx))
            .map(Response<Array<TownLifeCommentData>>.self, using: JSONDecoder())
            .map { response -> Array<TownLifeCommentData> in
                return response.data
            }
    }
    
    func saveTownLife(townLifeRequest: TownLifeRequest) -> Single<Void> {
        return provider.rx.request(.saveTownLife(townLifeRequest: townLifeRequest))
            .map { response -> Void in
                return Void()
            }
    }
    
    func updateTownLife(idx: Int, townLifeRequest: TownLifeRequest) -> Single<Void> {
        return provider.rx.request(.updateTownLife(idx: idx, townLifeRequest: townLifeRequest))
            .map { response -> Void in
                return Void()
            }
    }
    
    func deleteTownLife(idx: Int) -> Single<Void> {
        return provider.rx.request(.deleteTownLife(idx: idx))
            .map { response -> Void in
                return Void()
            }
    }
}
