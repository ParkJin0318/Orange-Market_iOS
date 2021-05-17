//
//  MyInfoViewReactor.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/16.
//

import ReactorKit

class MyInfoViewReactor: Reactor {
    
    private lazy var userRepository: UserRepository = UserRepositoryImpl()
    
    var initialState: State = State(
        user: nil,
        isLoading: false,
        errorMessage: nil
    )
    
    enum Action {
        case fetchUserInfo
    }
    
    enum Mutation {
        case setUserInfo(User)
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var user: User?
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        
        switch mutation {
            case let .setUserInfo(user):
                state.user = user
                
            case let .setLoading(isLoading):
                state.isLoading = isLoading
                
            case let .setError(error):
                state.errorMessage = error.toMessage()
                state.isLoading = false
        }
        return state
    }
}
