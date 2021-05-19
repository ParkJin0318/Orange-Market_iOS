//
//  LoginViewReactor.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/15.
//

import ReactorKit

class LoginViewReactor: Reactor {
    
    lazy var repository: AuthRepository = AuthRepositoryImpl()
    
    lazy var initialState: State = State(
        userId: "",
        userPw: "",
        isEnabledLogin: false,
        isSuccessLogin: false,
        isLoading: false,
        errorMessage: nil
    )
    
    enum Action {
        case userId(String)
        case userPw(String)
        
        case login
    }
    
    enum Mutation {
        case setUserId(String)
        case setUserPw(String)
        
        case setSuccessLogin(Bool)
        
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var userId: String
        var userPw: String
        
        var isEnabledLogin: Bool
        var isSuccessLogin: Bool
        
        var isLoading: Bool
        var errorMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case let .userId(id):
                return Observable.just(Mutation.setUserId(id))
                
            case let .userPw(pw):
                return Observable.just(Mutation.setUserPw(pw))
                
            case .login:
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    repository.login(loginRequest: LoginRequest(userId: currentState.userId, userPw: currentState.userPw))
                        .asObservable()
                        .map { Mutation.setSuccessLogin(true) },
                    .just(Mutation.setLoading(false)),
                ]).catch { .just(Mutation.setError($0)) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        
        switch mutation {
            case let .setUserId(id):
                state.userId = id
                state.isEnabledLogin = !state.userId.isEmpty && !state.userPw.isEmpty
                
            case let .setUserPw(pw):
                state.userPw = pw
                state.isEnabledLogin = !state.userId.isEmpty && !state.userPw.isEmpty
                
            case let .setSuccessLogin(isSuccessLogin):
                state.isSuccessLogin = isSuccessLogin
                
            case let .setLoading(isLoading):
                state.isLoading = isLoading
                
            case let .setError(error):
                state.errorMessage = error.toMessage()
                state.isLoading = false
        }
        return state
    }
    
}
