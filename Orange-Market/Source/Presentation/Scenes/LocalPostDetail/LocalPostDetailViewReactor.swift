//
//  LocalPostDetailViewReactor.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/20.
//

import ReactorKit

class LocalPostDetailViewReactor: Reactor {
    
    private lazy var localRepository: LocalRepository = LocalRepositoryImpl()
    
    var initialState: State = State(localPost: nil)
    
    enum Action {
        case fetchLocalPost(Int)
    }
    
    enum Mutation {
        case setLocalPost(LocalPost)
    }
    
    struct State {
        var localPost: LocalPost?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case let .fetchLocalPost(idx):
                return Observable.concat([
                    localRepository.getLocalPost(idx: idx)
                        .asObservable()
                        .map { Mutation.setLocalPost($0) }
                ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
            case let .setLocalPost(post):
                state.localPost = post
        }
        
        return state
    }
}
