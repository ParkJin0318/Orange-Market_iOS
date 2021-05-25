//
//  LocalPostDetailViewReactor.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/20.
//

import ReactorKit

class LocalPostDetailViewReactor: Reactor {
    
    private lazy var userRepository: UserRepository = UserRepositoryImpl()
    private lazy var localRepository: LocalRepository = LocalRepositoryImpl()
    
    var initialState: State = State(
        user: nil,
        localPost: nil,
        localComments: [],
        isSuccessComment: false,
        comment: "",
        isLoading: false,
        errorMessage: nil
    )
    
    enum Action {
        case fetchUserInfo
        case fetchLocalPost(Int)
        case fetchLocalComments(Int)
        
        case sendComment(Int)
        case comment(String)
    }
    
    enum Mutation {
        case setUserInfo(User)
        case setLocalPost(LocalPost)
        case setLocalComments([LocalComment])
        
        case setSuccessComment(Bool)
        case setComment(String)
        
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var user: User?
        var localPost: LocalPost?
        var localComments: [LocalComment]
        
        var isSuccessComment: Bool
        var comment: String
        
        var isLoading: Bool
        var errorMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .fetchUserInfo:
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    userRepository.getUserProfile()
                        .asObservable()
                        .map { Mutation.setUserInfo($0) },
                        .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
            
            case let .fetchLocalPost(idx):
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    localRepository.getLocalPost(idx: idx)
                        .asObservable()
                        .map { Mutation.setLocalPost($0) },
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
                
            case let .fetchLocalComments(idx):
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    localRepository.getAllComment(idx: idx)
                        .asObservable()
                        .map { Mutation.setLocalComments($0) },
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
                
            case let .comment(comment):
                return .just(Mutation.setComment(comment))
                
            case let .sendComment(idx):
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    validateComment(idx),
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
        }
    }
    
    private func validateComment(_ idx: Int) -> Observable<Mutation> {
        if (currentState.comment.isEmpty) {
            return .error(OrangeError.error(message: "댓글을 입력해주세요."))
        }
        
        return localRepository.saveComment(
            request: LocalCommentRequest(
                postIdx: idx,
                comment: currentState.comment,
                userIdx: currentState.user?.idx ?? -1
            )).asObservable()
            .map { Mutation.setSuccessComment(true) }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        
        switch mutation {
            case let .setUserInfo(user):
                state.user = user
                
            case let .setLocalPost(post):
                state.localPost = post
                
            case let .setLocalComments(comments):
                state.isSuccessComment = false
                state.localComments = comments
                
            case let .setComment(comment):
                state.comment = comment
                    
            case let .setSuccessComment(isSuccess):
                state.isSuccessComment = isSuccess
                state.comment = ""
                
            case let .setLoading(isLoading):
                state.isLoading = isLoading
                
            case let .setError(error):
                state.errorMessage = error.toMessage()
                state.isLoading = false
        }
        
        return state
    }
}
