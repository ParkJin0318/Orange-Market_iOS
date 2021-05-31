//
//  LocalPostAddViewReactor.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/26.
//

import ReactorKit

class LocalPostAddViewReactor: Reactor {
    
    private lazy var userRepository: UserRepository = UserRepositoryImpl()
    private lazy var localRepository: LocalRepository = LocalRepositoryImpl()
    
    var initialState: State = State(
        topicIdx: nil,
        topic: "게시글의 주제를 선택해주세요.",
        content: "",
        localPost: nil,
        user: nil,
        isSuccess: false,
        isLoading: false,
        errorMessage: nil
    )
    
    enum Action {
        case topicIdx(Int)
        case topic(String)
        case content(String)
        
        case fetchLocalPost(LocalPost?)
        case savePost
        case updatePost
    }
    
    enum Mutation {
        case setTopicIdx(Int)
        case setTopic(String)
        case setContent(String)
        
        case setLocalPost(LocalPost)
        case setUser(User)
        case setSuccess(Bool)
        
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var topicIdx: Int?
        var topic: String
        var content: String
        
        var localPost: LocalPost?
        var user: User?
        var isSuccess: Bool
        
        var isLoading: Bool
        var errorMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case let .topicIdx(idx):
                return Observable.just(Mutation.setTopicIdx(idx))
            
            case let .topic(topic):
                return Observable.just(Mutation.setTopic(topic))
                
            case let .content(content):
                return Observable.just(Mutation.setContent(content))
            
            case let .fetchLocalPost(localPost):
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    userRepository.getUserProfile()
                        .asObservable()
                        .map { Mutation.setUser($0) },
                    Observable.just(localPost)
                        .filter { $0 != nil }
                        .map { Mutation.setLocalPost($0!)},
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
                
            case .savePost:
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    savePost(action: .savePost),
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
                
            case .updatePost:
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    savePost(action: .updatePost),
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
        }
    }
    
    private func savePost(action: Action) -> Observable<Mutation> {
        
        if (currentState.topicIdx == nil) {
            return .error(OrangeError.error(message: "주제를 선택해주세요."))
        }
        
        if (currentState.content.isEmpty) {
            return .error(OrangeError.error(message: "내용을 입력해주세요."))
        }
        
        switch action {
            case .savePost:
                return localRepository.savePost(
                    request: LocalPostRequest(
                        topicIdx: currentState.topicIdx!,
                        contents: currentState.content,
                        userIdx: currentState.user!.idx,
                        city: currentState.user!.city
                    )
                ).asObservable()
                .map { Mutation.setSuccess(true) }
            
            case .updatePost:
                return localRepository.updatePost(
                    idx: currentState.localPost!.idx,
                    request: LocalPostRequest(
                        topicIdx: currentState.topicIdx!,
                        contents: currentState.content,
                        userIdx: currentState.localPost!.userIdx,
                        city: currentState.localPost!.city
                    )
                ).asObservable()
                .map { Mutation.setSuccess(true) }
                
            default:
                break
        }
        
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        
        switch mutation {
            case let .setTopicIdx(idx):
                state.topicIdx = idx
                
            case let .setTopic(topic):
                state.topic = topic
                
            case let .setContent(content):
                state.content = content
                
            case let .setLocalPost(post):
                state.localPost = post
                state.topicIdx = post.topicIdx
                state.topic = post.topic
                state.content = post.contents
                
            case let .setUser(user):
                state.user = user
                
            case let .setSuccess(isSuccess):
                state.isSuccess = isSuccess
                
            case let .setLoading(isLoading):
                state.isLoading = isLoading
                
            case let .setError(error):
                state.errorMessage = error.toMessage()
                state.isLoading = false
        }
        
        return state
    }
}
