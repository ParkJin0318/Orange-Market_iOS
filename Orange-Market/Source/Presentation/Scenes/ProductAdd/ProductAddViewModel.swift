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
        let titleText = PublishSubject<String>()
        let priceText = PublishSubject<String>()
        let contentText = PublishSubject<String>()
        let tapComplete = PublishSubject<Void>()
    }
    
    struct Output {
        var imageList = Array<String>()
        let isReloadData = PublishRelay<Bool>()
        let completedMessage = PublishRelay<String>()
    }
    
    lazy var input: Input = Input()
    lazy var output: Output = Output()
    
    private lazy var authRepository: AuthRepository = AuthRepositoryImpl()
    private lazy var productRepository: ProductRepository = ProductRepositoryImpl()
    private lazy var uploadRepository: UploadRepository = UploadRepositoryImpl()
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        self.tapComplete()
    }
    
    func uploadImage(image: UIImage) {
        uploadRepository.uploadImage(image: image)
            .subscribe { [weak self] data in
                self?.output.imageList.append(data)
                self?.output.isReloadData.accept(true)
            } onError: { error in
                print(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
    func tapComplete() {
        input.tapComplete
            .withLatestFrom(Observable.combineLatest(
                self.authRepository.getUserProfile().asObservable(),
                input.titleText,
                input.priceText,
                input.contentText
            )).flatMap {
                self.saveProduct(user: $0.0, title: $0.1, price: $0.2, content: $0.3)
            }.first()
            .filter { $0 != nil }
            .subscribe { data in
                self.output
                    .completedMessage.accept(data!)
            } onError: { error in
                self.output
                    .completedMessage.accept(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
    func saveProduct(user: User, title: String, price: String, content: String) -> Single<String> {
        return productRepository.saveProduct(productRequest: ProductRequest(
            title: title,
            contents: content,
            price: price,
            isSold: 0,
            userIdx: user.idx,
            city: user.city,
            imageList: output.imageList
        ))
    }
}
