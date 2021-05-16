//
//  HomeViewReactor.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/16.
//

import ReactorKit

class HomeViewReactor: Reactor {
    
    private lazy var productRepository: ProductRepository = ProductRepositoryImpl()
    
    var initialState: State = State(
        products: [],
        isLoading: false,
        errorMessage: nil
    )
    
    enum Action {
        case fetchProduct
    }
    
    enum Mutation {
        case setAllProduct([Product])
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var products: [Product]
        var isLoading: Bool
        var errorMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .fetchProduct:
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    productRepository.getAllProduct()
                        .asObservable()
                        .map { Mutation.setAllProduct($0) },
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        
        switch mutation {
            case let .setAllProduct(products):
                state.products = products
                
            case let .setLoading(isLoading):
                state.isLoading = isLoading
                
            case let .setError(error):
                state.errorMessage = error.toMessage()
                state.isLoading = false
        }
        return state
    }
}
