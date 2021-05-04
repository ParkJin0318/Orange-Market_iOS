//
//  SalesListViewModel.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/04.
//

import Foundation
import RxSwift
import RxCocoa

class SalesListViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        var productList = Array<Product>()
        var onReloadEvent = PublishRelay<Bool>()
    }
    
    lazy var input: Input = Input()
    lazy var output: Output = Output()
    
    private lazy var productRepository: ProductRepository = ProductRepositoryImpl()
    private lazy var authRepository: AuthRepository = AuthRepositoryImpl()
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    
    func getProducts() {
        productRepository.getAllMyProduct()
            .subscribe { [weak self] data in
                guard let self = self else { return }
                
                self.output.productList = data.sorted(by: { $0.idx > $1.idx })
                self.output.onReloadEvent.accept(true)
            } onFailure: { [weak self] error in
                
            }.disposed(by: disposeBag)
    }
}
