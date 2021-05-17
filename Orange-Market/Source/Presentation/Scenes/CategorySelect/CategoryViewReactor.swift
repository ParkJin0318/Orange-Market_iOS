//
//  CategoryViewReactor.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/16.
//

import ReactorKit

class CategorySelectViewReactor: Reactor {
    
    private lazy var productRepository: ProductRepository = ProductRepositoryImpl()
    
    var initialState: State = State(
        categories: [],
        isUpdateCategory: false,
        isLoading: false,
        errorMessage: nil
    )
    
    enum Action {
        case fetchCategory
        case updateCategory(Int)
    }
    
    enum Mutation {
        case setAllCategory([Category])
        case updateCategory(Bool)
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var categories: [Category]
        var isUpdateCategory: Bool
        var isLoading: Bool
        var errorMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .fetchCategory:
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    productRepository.getAllCategory()
                        .asObservable()
                        .map { Mutation.setAllCategory($0) },
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
                
            case let .updateCategory(idx):
                return Observable.concat([
                    productRepository.updateCategory(idx: idx)
                        .asObservable()
                        .map { Mutation.updateCategory(true) }
                ]).catch { .just(Mutation.setError($0)) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        
        switch mutation {
            case let .setAllCategory(categories):
                state.categories = categories
                
            case let .updateCategory(isUpdate):
                state.isUpdateCategory = isUpdate
                
            case let .setLoading(isLoading):
                state.isLoading = isLoading
                
            case let .setError(error):
                state.errorMessage = error.toMessage()
                state.isLoading = false
        }
        return state
    }
}
