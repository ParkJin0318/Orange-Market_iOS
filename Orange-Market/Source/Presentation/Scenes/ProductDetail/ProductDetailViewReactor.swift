//
//  ProductDetailViewReactor.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/16.
//

import ReactorKit

class ProductDetailViewReactor: Reactor {
    
    private lazy var userRepository: UserRepository = UserRepositoryImpl()
    private lazy var prouductRepository: ProductRepository = ProductRepositoryImpl()
    
    var initialState: State = State(
        product: nil,
        isMyProduct: false,
        isLikeProduct: false,
        isSuccessSold: false,
        isSuccessDelete: false,
        isSuccessLike: false,
        isLoading: false,
        errorMessage: nil
    )
    
    enum Action {
        case fetchProduct(Int)
        case updateSold(Int)
        case deleteProduct(Int)
        case likeProduct(Int)
    }
    
    enum Mutation {
        case setProduct(ProductDetail, User)
        case updateSold(Bool)
        case deleteProduct(Bool)
        case likeProduct(Bool)
        
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var product: ProductDetail?
        
        var isMyProduct: Bool
        var isLikeProduct: Bool
        
        var isSuccessSold: Bool
        var isSuccessDelete: Bool
        var isSuccessLike: Bool
        
        var isLoading: Bool
        var errorMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case let .fetchProduct(idx):
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    fetchProduct(idx: idx),
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
                
            case let .updateSold(idx):
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    prouductRepository.updateSold(idx: idx)
                        .asObservable()
                        .map { Mutation.updateSold(true) },
                    fetchProduct(idx: idx),
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
                
            case let .deleteProduct(idx):
                return Observable.concat([
                    prouductRepository.deleteProduct(idx: idx)
                        .asObservable()
                        .map { Mutation.deleteProduct(true) }
                ]).catch { .just(Mutation.setError($0)) }
                
            case let .likeProduct(idx):
                return Observable.concat([
                    prouductRepository.likeProduct(idx: idx)
                        .asObservable()
                        .map { Mutation.likeProduct(true) },
                    fetchProduct(idx: idx),
                ]).catch { .just(Mutation.setError($0)) }
        }
    }
    
    private func fetchProduct(idx: Int) -> Observable<Mutation> {
        return Single.zip(
            prouductRepository.getProduct(idx: idx),
            userRepository.getUserProfile()
        ).asObservable()
        .map { Mutation.setProduct($0.0, $0.1)}
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        
        switch mutation {
            case let .setProduct(product, user):
                state.product = product
                state.isMyProduct = product.userIdx != user.idx
                state.isLikeProduct = product.likeUsers.contains(user.idx)
                
            case let .updateSold(isSuccess):
                state.isSuccessSold = isSuccess
                
            case let .deleteProduct(isSuccess):
                state.isSuccessDelete = isSuccess
                
            case let .likeProduct(isSuccess):
                state.isSuccessLike = isSuccess
                
            case let .setLoading(isLoading):
                state.isLoading = isLoading
                
            case let .setError(error):
                state.errorMessage = error.toMessage()
                state.isLoading = false
        }
        return state
    }
}
