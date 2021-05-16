//
//  CategoryListViewReactor.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/16.
//

import ReactorKit

class CategoryListViewReactor: Reactor {
    
    private lazy var productRepository: ProductRepository = ProductRepositoryImpl()
    
    var initialState: State = State(
        categories: [],
        isReloadData: false,
        isLoading: false,
        errorMessage: nil
    )
    
    enum Action {
        case fetchCategory
    }
    
    enum Mutation {
        case setAllCategory([Category])
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var categories: [Category]
        var isReloadData: Bool
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        
        switch mutation {
            case let .setAllCategory(categories):
                state.categories = categories
                state.isReloadData = !categories.map { $0.idx }.elementsEqual(state.categories.map { $0.idx })
                
            case let .setLoading(isLoading):
                state.isLoading = isLoading
                
            case let .setError(error):
                state.errorMessage = error.toMessage()
                state.isLoading = false
        }
        return state
    }
}