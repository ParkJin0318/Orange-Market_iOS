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
    }
    
    lazy var input: Input = Input()
    lazy var output: Output = Output()
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var prouductRepository: ProductRepository = ProductRepositoryImpl()
    private lazy var userRepository: UserRepository = UserRepositoryImpl()
    
    func getProduct(idx: Int) {
        prouductRepository.getProduct(idx: idx)
            .subscribe { [weak self] data in
                self?.output.imageList = data.imageList
                self?.output.productData.accept(data)
            } onError: { error in
                print(error)
            }.disposed(by: disposeBag)
    }
}
