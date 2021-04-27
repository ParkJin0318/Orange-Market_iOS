//
//  ProductAddViewModel.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/16.
//

import Foundation
import RxSwift
import RxCocoa

class ProductAddViewModel: ViewModelType {
    
    struct Input {
        let product = PublishSubject<ProductDetail?>()
        let titleText = PublishSubject<String>()
        let priceText = PublishSubject<String>()
        let contentText = PublishSubject<String>()
        
        let tapSave = PublishSubject<Void>()
        let tapUpdate = PublishSubject<Void>()
    }
    
    struct Output {
        var imageList = Array<String>()
        let isReloadData = PublishRelay<Bool>()
        let completedMessage = PublishRelay<String>()
    }
    
    lazy var input: Input = Input()
    lazy var output: Output = Output()
    
    private lazy var userRepository: UserRepository = UserRepositoryImpl()
    private lazy var productRepository: ProductRepository = ProductRepositoryImpl()
    private lazy var uploadRepository: UploadRepository = UploadRepositoryImpl()
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        save()
        update()
    }
    
    func uploadImage(image: UIImage) {
        uploadRepository.uploadImage(image: image)
            .subscribe { [weak self] data in
                self?.output.imageList.append(data)
                self?.output.isReloadData.accept(true)
            } onFailure: { error in
                self.output.completedMessage.accept(error.toMessage())
            }.disposed(by: disposeBag)
    }
    
    func save() {
        input.tapSave
            .withLatestFrom(Observable.combineLatest(
                userRepository.getUserProfile().asObservable(),
                input.titleText,
                input.priceText,
                input.contentText
            ))
            .withUnretained(self)
            .flatMap { $0.0.saveProduct(user: $0.1.0, title: $0.1.1, price: $0.1.2, content: $0.1.3) }
            .subscribe { data in
                self.output.completedMessage.accept(data)
            } onError: { error in
                self.output.completedMessage.accept(error.toMessage())
            }.disposed(by: disposeBag)
    }
    
    func update() {
        input.tapUpdate
            .withLatestFrom(Observable.combineLatest(
                input.product,
                input.titleText,
                input.priceText,
                input.contentText
            ))
            .withUnretained(self)
            .flatMap { $0.0.updateProduct(product: $0.1.0!, title: $0.1.1, price: $0.1.2, content: $0.1.3) }
            .subscribe { data in
                self.output.completedMessage.accept(data)
            } onError: { error in
                self.output.completedMessage.accept(error.toMessage())
            }.disposed(by: disposeBag)
    }
    
    func saveProduct(user: User, title: String, price: String, content: String) -> Single<String> {
        return productRepository.saveProduct(productRequest: ProductRequest(
            categoryIdx: 1,
            title: title,
            contents: content,
            price: price,
            isSold: 0,
            userIdx: user.idx,
            city: user.city,
            imageList: output.imageList
        ))
    }
    
    func updateProduct(product: ProductDetail, title: String, price: String, content: String) -> Single<String> {
        return productRepository.updateProduct(idx: product.idx, productRequest: ProductRequest(
            categoryIdx: 1,
            title: title,
            contents: content,
            price: price,
            isSold: product.getIsSold(),
            userIdx: product.userIdx,
            city: product.city,
            imageList: output.imageList
        ))
    }
}
