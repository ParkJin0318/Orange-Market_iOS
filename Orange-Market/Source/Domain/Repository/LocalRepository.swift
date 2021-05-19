//
//  LocalRepository.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/19.
//

import Foundation
import RxSwift

protocol LocalRepository {
    func getAllLocalPost() -> Single<Array<LocalPost>>
    
    func getLocalPost(idx: Int) -> Single<LocalPost>
    
    func getAllComment(idx: Int) -> Single<Array<LocalComment>>
    
    func getAllTopic() -> Single<Array<LocalTopic>>
    
    func savePost(request: LocalPostRequest) -> Single<Void>
    
    func saveComment(request: LocalCommentRequest) -> Single<Void>
    
    func updatePost(idx: Int, request: LocalPostRequest) -> Single<Void>
    
    func deletePost(idx: Int) -> Single<Void>
    
    func deleteComment(idx: Int) -> Single<Void>
}
