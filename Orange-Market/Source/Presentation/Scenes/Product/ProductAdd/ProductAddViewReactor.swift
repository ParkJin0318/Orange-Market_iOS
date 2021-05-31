//
//  ProductAddViewReactor.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/17.
//

import ReactorKit

class ProductAddViewReactor: Reactor {
    
    private lazy var userRepository: UserRepository = UserRepositoryImpl()
    private lazy var productRepository: ProductRepository = ProductRepositoryImpl()
    private lazy var uploadRepository: UploadRepository = UploadRepositoryImpl()
    
    var initialState: State = State(
        images: [],
        title: "",
        categoryIdx: nil,
        category: "카테고리 선택",
        price: "",
        content: "",
        product: nil,
        user: nil,
        isSuccess: false,
        isLoading: false,
        errorMessage: nil
    )
    
    enum Action {
        case image(String)
        case title(String)
        case categoryIdx(Int)
        case category(String)
        case price(String)
        case content(String)
        
        case fetchProduct(Product?)
        case uploadImage(UIImage)
        case saveProduct
        case updateProduct
        case removeImage(Int)
    }
    
    enum Mutation {
        case setImage(String)
        case setTitle(String)
        case setCategoryIdx(Int)
        case setCategory(String)
        case setPrice(String)
        case setContent(String)
        
        case setProduct(Product)
        case setUser(User)
        case setSuccess(Bool)
        case setRemoveImage(Int)
        
        case setLoading(Bool)
        case setError(Error)
    }
    
    struct State {
        var images: [String]
        var title: String
        var categoryIdx: Int?
        var category: String
        var price: String
        var content: String
        
        var product: Product?
        var user: User?
        
        var isSuccess: Bool
        
        var isLoading: Bool
        var errorMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case let .image(image):
                return Observable.just(Mutation.setImage(image))
                
            case let .title(title):
                return Observable.just(Mutation.setTitle(title))
                
            case let .categoryIdx(idx):
                return Observable.just(Mutation.setCategoryIdx(idx))
                
            case let .category(category):
                return Observable.just(Mutation.setCategory(category))
                
            case let .price(price):
                return Observable.just(Mutation.setPrice(price))
                
            case let .content(content):
                return Observable.just(Mutation.setContent(content))
        
            case let .fetchProduct(product):
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    userRepository.getUserProfile()
                        .asObservable()
                        .map { Mutation.setUser($0) },
                    Observable.just(product)
                        .filter { $0 != nil }
                        .map { Mutation.setProduct($0!)},
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
                
            case let .uploadImage(image):
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    uploadRepository.uploadImage(image: image)
                        .asObservable()
                        .map { Mutation.setImage($0) },
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
                
            case .saveProduct:
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    saveRequest(action: .saveProduct),
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
                
            case .updateProduct:
                return Observable.concat([
                    .just(Mutation.setLoading(true)),
                    saveRequest(action: .updateProduct),
                    .just(Mutation.setLoading(false))
                ]).catch { .just(Mutation.setError($0)) }
                
            case let .removeImage(index):
                return Observable.just(Mutation.setRemoveImage(index))
        }
    }
    
    private func saveRequest(action: Action) -> Observable<Mutation> {
        
        if (currentState.images.isEmpty) {
            return .error(OrangeError.error(message: "이미지를 선택해주세요"))
        }
        
        if (currentState.categoryIdx == nil) {
            return .error(OrangeError.error(message: "카테고리를 선택해주세요."))
        }
        
        if (currentState.title.isEmpty ||
            currentState.content.isEmpty ||
            currentState.price.isEmpty) {
            return .error(OrangeError.error(message: "빈 칸 없이 입력해주세요."))
        }
        
        switch action {
            case .saveProduct:
                return productRepository.saveProduct(
                    productRequest: ProductRequest(
                        categoryIdx: currentState.categoryIdx!,
                        title: currentState.title,
                        contents: currentState.content,
                        price: currentState.price,
                        isSold: 0,
                        userIdx: currentState.user!.idx,
                        city: currentState.user!.city,
                        imageList: currentState.images
                    )
                ).asObservable()
                .map { Mutation.setSuccess(true) }
                
            case .updateProduct:
                return productRepository.updateProduct(
                    idx: currentState.product!.idx,
                    productRequest: ProductRequest(
                        categoryIdx: currentState.categoryIdx!,
                        title: currentState.title,
                        contents: currentState.content,
                        price: currentState.price,
                        isSold: currentState.product!.getIsSold(),
                        userIdx: currentState.product!.userIdx,
                        city: currentState.product!.city,
                        imageList: currentState.images
                    )
                ).asObservable()
                .map { Mutation.setSuccess(true) }
                
            default:
                break
        }
        
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.errorMessage = nil
        
        switch mutation {
            case let .setImage(image):
                var images: [String] = state.images
                images.append(image)
                
                state.images = images
                
            case let .setTitle(title):
                state.title = title
                
            case let .setCategoryIdx(idx):
                state.categoryIdx = idx
                
            case let .setCategory(category):
                state.category = category
                
            case let .setPrice(price):
                state.price = price
                
            case let .setContent(content):
                state.content = content
                
            case let .setProduct(product):
                state.product = product
                state.images = product.images
                state.title = product.title
                state.categoryIdx = product.categoryIdx
                state.category = product.category
                state.price = product.price
                state.content = product.contents
                
            case let .setUser(user):
                state.user = user
                
            case let .setSuccess(isSuccess):
                state.isSuccess = isSuccess
                
            case let .setRemoveImage(index):
                var images = state.images
                images.remove(at: index)
                state.images = images
                
            case let .setLoading(isLoading):
                state.isLoading = isLoading
                
            case let .setError(error):
                state.errorMessage = error.toMessage()
                state.isLoading = false
        }
        return state
    }
}
