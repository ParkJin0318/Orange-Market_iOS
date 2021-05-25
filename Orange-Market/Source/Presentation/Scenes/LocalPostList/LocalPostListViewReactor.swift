//
//  LocalPostListViewReactor.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/20.
//

import ReactorKit

class LocalPostListViewReactor: Reactor {
    
    private lazy var localRepository: LocalRepository = LocalRepositoryImpl()
    
    var initialState: State = State(
        localPosts: [],
        localTopics: [],
        isLoading: false,
        errorMessage: nil
    )
    
    enum Action {
        case fetchLocalPost
        case fetchLocalTopic
    }
    
    enum Mutation {
        case setLocalPost([LocalPost])
        case setLocalTopic([LocalTopic])
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var localPosts: [LocalPost]
        var localTopics: [LocalTopic]
        var isLoading: Bool
        var errorMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .fetchLocalPost:
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    localRepository.getAllLocalPost()
                        .asObservable()
                        .map { Mutation.setLocalPost($0) },
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
                
            case .fetchLocalTopic:
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    localRepository.getAllTopic()
                        .asObservable()
                        .map { Mutation.setLocalTopic($0) },
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        
        switch mutation {
            case let .setLocalPost(posts):
                state.localPosts = posts
                
            case let .setLocalTopic(topics):
                var localTopics: [LocalTopic] = []
                localTopics.append(LocalTopic(idx: -1, name: "", isSelected: false))
                localTopics.append(contentsOf: topics)
                state.localTopics = localTopics
                
            case let .setLoading(isLoading):
                state.isLoading = isLoading
                
            case let .setError(error):
                state.errorMessage = error.toMessage()
                state.isLoading = false
        }
        return state
    }
}
