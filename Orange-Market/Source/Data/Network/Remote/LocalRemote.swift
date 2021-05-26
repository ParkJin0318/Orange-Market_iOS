//
//  LocalRemote.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/13.
//

import Foundation
import RxSwift
import Moya

class LocalRemote {
    private lazy var provider: MoyaProvider<LocalAPI> = MoyaProvider()
    
    func getAllLocalPost(city: String) -> Single<Array<LocalPost>> {
        return provider.rx.request(.getAllPost(city: city))
            .map(Response<Array<LocalPost>>.self, using: JSONDecoder())
            .map { response -> Array<LocalPost> in
                return response.data
            }
    }
    
    func getLocalPost(idx: Int) -> Single<LocalPost> {
        return provider.rx.request(.getPost(idx: idx))
            .map(Response<LocalPost>.self, using: JSONDecoder())
            .map { response -> LocalPost in
                return response.data
            }
    }
    
    func getAllComment(idx: Int) -> Single<Array<LocalCommentData>> {
        return provider.rx.request(.getAllComment(idx: idx))
            .map(Response<Array<LocalCommentData>>.self, using: JSONDecoder())
            .map { response -> Array<LocalCommentData> in
                return response.data
            }
    }
    
    func getAllTopic() -> Single<Array<LocalTopicData>> {
        return provider.rx.request(.getAllTopic)
            .map(Response<Array<LocalTopicData>>.self, using: JSONDecoder())
            .map { response -> Array<LocalTopicData> in
                return response.data
            }
    }
    
    func savePost(request: LocalPostRequest) -> Single<Void> {
        return provider.rx.request(.savePost(townLifeRequest: request))
            .map { response -> Void in
                return Void()
            }
    }
    
    func saveComment(request: LocalCommentRequest) -> Single<Void> {
        return provider.rx.request(.saveComment(localCommentRequest: request))
            .map { response -> Void in
                return Void()
            }
    }
    
    func updatePost(idx: Int, request: LocalPostRequest) -> Single<Void> {
        return provider.rx.request(.updatePost(idx: idx, townLifeRequest: request))
            .map { response -> Void in
                return Void()
            }
    }
    
    func deletePost(idx: Int) -> Single<Void> {
        return provider.rx.request(.deletePost(idx: idx))
            .map { response -> Void in
                return Void()
            }
    }
    
    func deleteComment(idx: Int) -> Single<Void> {
        return provider.rx.request(.deleteComment(idx: idx))
            .map { response -> Void in
                return Void()
            }
    }
}
