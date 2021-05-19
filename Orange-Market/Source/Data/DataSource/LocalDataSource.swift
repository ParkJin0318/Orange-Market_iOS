//
//  LocalDataSource.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/19.
//

import Foundation
import RxSwift

class LocalDataSource {
    
    private lazy var userRemote = UserRemote()
    private lazy var localRemote = LocalRemote()
    private lazy var topicCache = LocalTopicCache()
    
    func getAllLocalPost() -> Single<Array<LocalPost>> {
        return userRemote.getUserProfile()
            .flatMap { profile in
                Single.zip(
                    self.localRemote.getAllLocalPost(city: profile.city),
                    self.getAllTopic()
                ) { postDataList, topicList in
                    
                    let selectTopicList = topicList
                        .filter { $0.isSelected }
                        .map { $0.idx }
                    
                    return postDataList
                        .filter { selectTopicList.contains($0.topicIdx) }
                }
            }
    }
    
    func getLocalPost(idx: Int) -> Single<LocalPost> {
        return localRemote.getLocalPost(idx: idx)
    }
    
    func getAllComment(idx: Int) -> Single<Array<LocalComment>> {
        return localRemote.getAllComment(idx: idx)
    }
    
    func getAllTopic() -> Single<Array<LocalTopic>> {
        return topicCache.getAllTopic()
            .map { $0.map { $0.toModel() } }
            .catch { error in
                self.localRemote
                    .getAllTopic()
                    .map { $0.map { $0.toModel() } }
                    .flatMap { topicList in
                        self.topicCache
                            .insertTopic(topicList.map { $0.toEntity() })
                            .flatMap { _ in .just(topicList)}
                    }
            }
    }
    
    func savePost(request: LocalPostRequest) -> Single<Void> {
        return localRemote.savePost(request: request)
    }
    
    func saveComment(request: LocalCommentRequest) -> Single<Void> {
        return localRemote.saveComment(request: request)
    }
    
    func updatePost(idx: Int, request: LocalPostRequest) -> Single<Void> {
        return localRemote.updatePost(idx: idx, request: request)
    }
    
    func deletePost(idx: Int) -> Single<Void> {
        return localRemote.deletePost(idx: idx)
    }
    
    func deleteComment(idx: Int) -> Single<Void> {
        return localRemote.deleteComment(idx: idx)
    }
}
