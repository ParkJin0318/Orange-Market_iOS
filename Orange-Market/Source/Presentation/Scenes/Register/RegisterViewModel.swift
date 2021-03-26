//
//  RegisterViewModel.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/26.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterViewModel: ViewModelType {
    
    lazy var input: Input = Input()
    lazy var output: Output = Output()
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var authRepository: AuthRepository = AuthRepositoryImpl()
    private lazy var uploadRepository: UploadRepository = UploadRepositoryImpl()
    
    struct Input {
        
    }
    
    struct Output {
        let imageUrl = PublishRelay<String>()
    }
    
    func uploadImage(image: UIImage) {
        uploadRepository.uploadImage(image: image)
            .subscribe { [weak self] data in
                self?.output.imageUrl.accept(data)
            } onFailure: { error in
                print(error.localizedDescription)
            }.disposed(by: disposeBag)
    }
    
    func register() {
        
    }
}
