//
//  MyInfoEditViewReactor.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/16.
//

import ReactorKit

class MyInfoEditViewReactor: Reactor {
    
    private lazy var userRepository: UserRepository = UserRepositoryImpl()
    private lazy var uploadRepository: UploadRepository = UploadRepositoryImpl()
    
    var initialState: State = State(
        userName: "",
        imageUrl: nil,
        isSuccessUploadImage: nil,
        isSuccessUserInfo: false,
        isLoading: false,
        errorMessage: nil
    )
    
    enum Action {
        case name(String)
        case image(String)
        
        case fetchUserInfo
        case uploadImage(UIImage)
        case updateUerInfo
    }
    
    enum Mutation {
        case setName(String)
        case setImage(String)
        
        case setUserInfo(User)
        case setSuccessUploadImage(String)
        case setSuccessUpdateUserInfo(Bool)
        
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var userName: String
        var imageUrl: String?
        
        var isSuccessUploadImage: String?
        var isSuccessUserInfo: Bool
        
        var isLoading: Bool
        var errorMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        
        case let .name(name):
            return Observable.just(Mutation.setName(name))
            
        case let .image(image):
            return Observable.just(Mutation.setImage(image))
        
            case .fetchUserInfo:
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    userRepository.getUserProfile()
                        .asObservable()
                        .map { Mutation.setUserInfo($0) },
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
                
        case .updateUerInfo:
            return Observable.concat([
                .just(Mutation.setLoading(true)),
                userRepository.updateUser(userRequest: UserRequest(name: currentState.userName, profileImage: currentState.imageUrl))
                    .asObservable()
                    .map { Mutation.setSuccessUpdateUserInfo(true) },
                .just(Mutation.setLoading(false))
            ]).catch { .just(Mutation.setError($0)) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        
        switch mutation {
            case let .setName(name):
                state.userName = name
            
            case let .setImage(image):
                state.imageUrl = image
        
            case let .setUserInfo(user):
                state.userName = user.name
                state.imageUrl = user.profileImage
                
            case let .setSuccessUploadImage(image):
                state.isSuccessUploadImage = image
                
            case let .setSuccessUpdateUserInfo(isSuccess):
                state.isSuccessUserInfo = isSuccess
                
            case let .setLoading(isLoading):
                state.isLoading = isLoading
                
            case let .setError(error):
                state.errorMessage = error.toMessage()
                state.isLoading = false
        }
        return state
    }
}
