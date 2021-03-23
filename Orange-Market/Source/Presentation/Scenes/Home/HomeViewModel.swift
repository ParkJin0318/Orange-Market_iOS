//
//  HomeViewModel.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        var city = PublishRelay<String>()
        var productList = Array<Product>()
    }
    
    lazy var input: Input = Input()
    lazy var output: Output = Output()
    
    private lazy var productRepository: ProductRepository = ProductRepositoryImpl()
    private lazy var authRepository: AuthRepository = AuthRepositoryImpl()
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    
    func getProducts() {
        productRepository.getAllProduct()
            .subscribe { [weak self] data in
                guard let self = self else { return }
                
                self.output.productList = data
                self.output.city.accept(data.first?.city ?? "Error")
            } onFailure: { error in
                print(error)
            }.disposed(by: disposeBag)
    }
}
