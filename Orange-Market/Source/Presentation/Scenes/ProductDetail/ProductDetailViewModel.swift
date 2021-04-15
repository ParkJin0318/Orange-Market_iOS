//
//  ProductViewModel.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/18.
//

import Foundation
import RxSwift
import RxCocoa

class ProductDetailViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        let productData = PublishRelay<ProductDetail>()
        var imageList = Array<String>()
        
        let isDeleteHideen = PublishRelay<Bool>()
        let onReloadEvent = PublishRelay<Bool>()
        let onDeleteEvent = PublishRelay<String>()
        let onFailureEvent = PublishRelay<String>()
    }
    
    lazy var input: Input = Input()
    lazy var output: Output = Output()
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var userRepository: UserRepository = UserRepositoryImpl()
    private lazy var prouductRepository: ProductRepository = ProductRepositoryImpl()
    
    func getProduct(idx: Int) {
        Single.zip(
            userRepository.getUserProfile(),
            prouductRepository.getProduct(idx: idx)
        ).subscribe { [weak self] user, product in
            
            if (user.idx == product.userIdx) {
                self?.output.isDeleteHideen.accept(false)
            } else {
                self?.output.isDeleteHideen.accept(true)
            }
            
            self?.output.imageList = product.imageList
            self?.output.productData.accept(product)
            self?.output.onReloadEvent.accept(true)
        } onFailure: { [weak self] error in
            
            self?.output.onFailureEvent.accept(error.toMessage())
        }.disposed(by: disposeBag)
    }
    
    func deleteProduct(idx: Int) {
        prouductRepository.deleteProduct(idx: idx)
            .subscribe { [weak self] data in
                self?.output.onDeleteEvent.accept(data)
            } onFailure: { [weak self] error in
                
                self?.output.onFailureEvent.accept(error.toMessage())
            }.disposed(by: disposeBag)
    }
}
