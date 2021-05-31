//
//  TopicListViewReactor.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/26.
//

import ReactorKit

class TopicListViewReactor: Reactor {
    
    private lazy var localRepository: LocalRepository = LocalRepositoryImpl()
    
    var initialState: State = State(
        topics: [],
        tapItem: nil,
        isLoading: false,
        errorMessage: nil
    )
    
    enum Action {
        case fetchTopic
        case tapItem(Int)
    }
    
    enum Mutation {
        case setAllTopic([LocalTopic])
        case setTapItem(Int)
        
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var topics: [LocalTopic]
        var tapItem: LocalTopic?
        
        var isLoading: Bool
        var errorMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .fetchTopic:
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    localRepository.getAllTopic()
                        .asObservable()
                        .map { Mutation.setAllTopic($0) },
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
                
            case let .tapItem(index):
                return Observable.just(Mutation.setTapItem(index))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        
        switch mutation {
            case let .setAllTopic(topics):
                state.topics = topics
                
            case let .setTapItem(index):
                state.tapItem = state.topics[index]
                
            case let .setLoading(isLoading):
                state.isLoading = isLoading
                
            case let .setError(error):
                state.errorMessage = error.toMessage()
                state.isLoading = false
        }
        return state
    }
}
