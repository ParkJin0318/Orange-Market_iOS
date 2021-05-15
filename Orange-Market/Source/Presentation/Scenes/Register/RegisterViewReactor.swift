//
//  RegisterViewReactor.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/15.
//

import Foundation
import ReactorKit

class RegisterViewReactor: Reactor {
    
    private lazy var authRepository: AuthRepository = AuthRepositoryImpl()
    private lazy var uploadRepository: UploadRepository = UploadRepositoryImpl()
    
    var initialState: State = State(
        isSuccessRegister: false,
        isSuccessUploadImage: nil,
        isLoading: false,
        errorMessage: nil
    )
    
    enum Action {
        case register(RegisterRequest)
        case uploadImage(UIImage)
    }
    
    enum Mutation {
        case setSuccessRegister(Bool)
        case setSuccessUploadImage(String)
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var isSuccessRegister: Bool
        var isSuccessUploadImage: String?
        var isLoading: Bool
        var errorMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .register(registerRequest):
            return Observable.concat([
                .just(Mutation.setLoading(true)),
                authRepository.register(registerRequest: registerRequest)
                    .asObservable()
                    .map { Mutation.setSuccessRegister(true) },
                .just(Mutation.setLoading(false))
            ]).catch { .just(Mutation.setError($0)) }
            
        case let .uploadImage(image):
            return Observable.concat([
                .just(Mutation.setLoading(true)),
                uploadRepository.uploadImage(image: image)
                    .asObservable()
                    .map { Mutation.setSuccessUploadImage($0) },
                .just(Mutation.setLoading(false))
            ]).catch { .just(Mutation.setError($0)) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        
        switch mutation {
        case let .setSuccessRegister(isSuccess):
            state.isSuccessRegister = isSuccess
            
        case let .setSuccessUploadImage(image):
            state.isSuccessUploadImage = image
            
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            
        case let .setError(error):
            state.errorMessage = error.toMessage()
            state.isLoading = false
        }
        return state
    }
}
