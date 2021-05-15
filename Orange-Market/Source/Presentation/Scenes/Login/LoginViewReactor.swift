//
//  LoginReactor.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/15.
//

import ReactorKit

class LoginViewReactor: Reactor {
    
    lazy var repository: AuthRepository = AuthRepositoryImpl()
    
    lazy var initialState: State = State(
        loginRequest: LoginRequest(userId: "", userPw: ""),
        isEnabledLogin: false,
        isSuccessLogin: false,
        isLoading: false,
        onErrorMessage: nil
    )
    
    enum Action {
        case userId(String)
        case userPw(String)
        case login(LoginRequest)
    }
    
    enum Mutation {
        case setUserId(String)
        case setUserPw(String)
        
        case setEnabledLogin
        case setSuccessLogin(Bool)
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var loginRequest: LoginRequest
        
        var isEnabledLogin: Bool
        var isSuccessLogin: Bool
        var isLoading: Bool
        var onErrorMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case let .userId(id):
                return Observable.concat([
                    .just(Mutation.setUserId(id)),
                    .just(Mutation.setEnabledLogin)
                ])
            case let .userPw(pw):
                return Observable.concat([
                    .just(Mutation.setUserPw(pw)),
                    .just(Mutation.setEnabledLogin)
                ])
            case let .login(loginRequest):
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    validate(.login(loginRequest)),
                    repository.login(loginRequest: loginRequest)
                        .asObservable()
                        .map { Mutation.setSuccessLogin(true) },
                    .just(Mutation.setLoading(false)),
                ]).catch { .just(Mutation.setError($0)) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.onErrorMessage = nil
        
        switch mutation {
            case let .setUserId(id):
                state.loginRequest = LoginRequest(
                    userId: id,
                    userPw: state.loginRequest.userPw
                )
                
            case let .setUserPw(pw):
                state.loginRequest = LoginRequest(
                    userId: state.loginRequest.userId,
                    userPw: pw
                )
                
            case .setEnabledLogin:
                state.isEnabledLogin =
                    !state.loginRequest.userId.isEmpty && !state.loginRequest.userPw.isEmpty
                
            case let .setSuccessLogin(isSuccessLogin):
                state.isSuccessLogin = isSuccessLogin
                
            case let .setLoading(isLoading):
                state.isLoading = isLoading
                
            case let .setError(error):
                state.onErrorMessage = error.toMessage()
                state.isLoading = false
                state.isSuccessLogin = false
        }
        return state
    }
    
}

extension LoginViewReactor {
    
    private func validate(_ action: Action) -> Observable<Mutation> {
        switch action {
            case let .login(loginRequest):
                if (loginRequest.userId.isEmpty) {
                    return .error(OrangeError.error(message: "아이디를 입력해주세요"))
                } else if (loginRequest.userPw.isEmpty) {
                    return .error(OrangeError.error(message: "비밀번호를 입력해주세요"))
                }
            default:
                break
        }
        return Observable.empty()
    }
}
