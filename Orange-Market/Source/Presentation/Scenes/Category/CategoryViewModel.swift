//
//  CategoryViewModel.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/26.
//

import Foundation
import RxSwift
import RxCocoa

class CategoryViewModel: ViewModelType {
    
    struct Input {
        
    }
    
    struct Output {
        var categoryList = Array<Category>()
        let onReloadEvent = PublishRelay<Bool>()
    }
    
    lazy var input: Input = Input()
    lazy var output: Output = Output()
    
    private lazy var productRepository: ProductRepository = ProductRepositoryImpl()
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    
    func getAllCategory() {
        productRepository.getAllCategory()
            .subscribe { [weak self] data in
                self?.output.categoryList = data
                self?.output.onReloadEvent.accept(true)
            } onFailure: { error in
                
            }.disposed(by: disposeBag)
    }
}
