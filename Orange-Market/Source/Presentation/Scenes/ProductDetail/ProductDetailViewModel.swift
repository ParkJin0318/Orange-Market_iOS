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
        var product: ProductDetail? = nil
        
        let isMyProduct = PublishRelay<Bool>()
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
            
            self?.output.imageList = product.imageList
            self?.output.isMyProduct.accept(user.idx != product.userIdx)
            
            self?.output.productData.accept(product)
            self?.output.product = product
            
            self?.output.onReloadEvent.accept(true)
        } onFailure: { [weak self] error in
            
            self?.output.onFailureEvent.accept(error.toMessage())
        }.disposed(by: disposeBag)
    }
    
    func updateSold(idx: Int) {
        prouductRepository.updateSold(idx: idx)
            .subscribe { [weak self] data in
                
                self?.output.onFailureEvent.accept(data)
                self?.getProduct(idx: idx)
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
