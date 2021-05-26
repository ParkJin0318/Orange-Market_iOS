//
//  TopicSelectViewReactor.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/26.
//

import ReactorKit

class TopicSelectViewReactor: Reactor {
    
    private lazy var localRepository: LocalRepository = LocalRepositoryImpl()
    
    var initialState: State = State(
        topics: [],
        isUpdateTopic: false,
        isLoading: false,
        errorMessage: nil
    )
    
    enum Action {
        case fetchTopic
        case updateTopic(Int)
    }
    
    enum Mutation {
        case setAllTopic([LocalTopic])
        case updateTopic(Bool)
        
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var topics: [LocalTopic]
        var isUpdateTopic: Bool
        
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
                
            case let .updateTopic(idx):
                return Observable.concat([
                    localRepository.updateTopic(idx: idx)
                        .asObservable()
                        .map { Mutation.updateTopic(true) }
                ]).catch { .just(Mutation.setError($0)) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        
        switch mutation {
            case let .setAllTopic(topics):
                state.topics = topics
                
            case let .updateTopic(isUpdate):
                state.isUpdateTopic = isUpdate
                
            case let .setLoading(isLoading):
                state.isLoading = isLoading
                
            case let .setError(error):
                state.errorMessage = error.toMessage()
        }
        return state
    }
}
