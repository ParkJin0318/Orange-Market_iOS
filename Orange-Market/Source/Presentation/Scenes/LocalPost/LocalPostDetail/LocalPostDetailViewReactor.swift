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
        isSuccessDeleteLocalPost: false,
        isSuccessDeleteLocalComment: false,
        isSuccessSendComment: false,
        comment: "",
        isLoading: false,
        errorMessage: nil
    )
    
    enum Action {
        case fetchUserInfo
        case fetchLocalPost(Int)
        case fetchLocalComments(Int)
        
        case deleteLocalComment(Int)
        case deleteLocalPost(Int)
    
        case sendComment(Int)
        case comment(String)
    }
    
    enum Mutation {
        case setUserInfo(User)
        case setLocalPost(LocalPost)
        case setLocalComments([LocalComment])
        
        case setSuccessDeleteLocalPost(Bool)
        case setSuccessDeleteLocalComment(Bool)
        
        case setSuccessSendComment(Bool)
        case setComment(String)
        
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var user: User?
        var localPost: LocalPost?
        var localComments: [LocalComment]
        
        var isSuccessDeleteLocalPost: Bool
        var isSuccessDeleteLocalComment: Bool
        
        var isSuccessSendComment: Bool
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
                
            case let .deleteLocalPost(idx):
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    localRepository.deletePost(idx: idx)
                        .asObservable()
                        .map { Mutation.setSuccessDeleteLocalPost(true) },
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
                
            case let .deleteLocalComment(idx):
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    localRepository.deleteComment(idx: idx)
                        .asObservable()
                        .map { Mutation.setSuccessDeleteLocalComment(true) },
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
            .map { Mutation.setSuccessSendComment(true) }
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
                state.isSuccessSendComment = false
                state.isSuccessDeleteLocalComment = false
                state.localComments = comments
                
            case let .setSuccessDeleteLocalPost(isSuccess):
                state.isSuccessDeleteLocalPost = isSuccess
                
            case let .setSuccessDeleteLocalComment(isSuccess):
                state.isSuccessDeleteLocalComment = isSuccess
                
            case let .setComment(comment):
                state.comment = comment
                    
            case let .setSuccessSendComment(isSuccess):
                state.isSuccessSendComment = isSuccess
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
