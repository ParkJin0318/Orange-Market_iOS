//
//  LocalRepositoryImpl.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/19.
//

import Foundation
import RxSwift

class LocalRepositoryImpl: LocalRepository {
    
    private lazy var dataSource = LocalDataSource()
    
    func getAllLocalPost() -> Single<Array<LocalPost>> {
        return dataSource.getAllLocalPost()
    }
    
    func getAllLocalPost(topicIdx: Int) -> Single<Array<LocalPost>> {
        return dataSource.getAllLocalPost(topicIdx: topicIdx)
    }
    
    func getLocalPost(idx: Int) -> Single<LocalPost> {
        return dataSource.getLocalPost(idx: idx)
    }
    
    func getAllComment(idx: Int) -> Single<Array<LocalComment>> {
        return dataSource.getAllComment(idx: idx)
    }
    
    func getAllTopic() -> Single<Array<LocalTopic>> {
        return dataSource.getAllTopic()
    }
    
    func savePost(request: LocalPostRequest) -> Single<Void> {
        return dataSource.savePost(request: request)
    }
    
    func saveComment(request: LocalCommentRequest) -> Single<Void> {
        return dataSource.saveComment(request: request)
    }
    
    func updatePost(idx: Int, request: LocalPostRequest) -> Single<Void> {
        return dataSource.updatePost(idx: idx, request: request)
    }
    
    func deletePost(idx: Int) -> Single<Void> {
        return dataSource.deletePost(idx: idx)
    }
    
    func deleteComment(idx: Int) -> Single<Void> {
        return dataSource.deleteComment(idx: idx)
    }
}
