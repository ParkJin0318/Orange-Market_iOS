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
        var productList = Array<ProductData>()
    }
    
    lazy var input: Input = Input()
    lazy var output: Output = Output()
    
    lazy var userRepository: UserRepository = UserRepositoryImpl()
    lazy var productRepository: ProductRepository = ProductRepositoryImpl()
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        userRepository.getMyProfile()
            .flatMap { self.productRepository.getAllProduct(city: $0.city) }
            .subscribe { [weak self] data in
                guard let self = self else { return }
                
                self.output.productList = data
                self.output.city.accept(data.first?.city ?? "Error")
            } onError: { error in
                print(error)
            }.disposed(by: disposeBag)
    }
}
