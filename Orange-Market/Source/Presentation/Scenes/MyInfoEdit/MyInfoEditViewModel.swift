//
//  MyInfoEditViewModel.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/12.
//

import Foundation
import RxSwift
import RxCocoa

class MyInfoEditViewModel: ViewModelType {
    
    struct Input {
        let tapComplete = PublishSubject<Void>()
    }
    
    struct Output {
        let name = PublishRelay<String>()
        let profileImage = PublishRelay<String>()
        
        let onSuccessEvent = PublishRelay<Bool>()
        let onErrorEvent = PublishRelay<String>()
    }
    
    lazy var input: Input = Input()
    lazy var output: Output = Output()
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var userRepository: UserRepository = UserRepositoryImpl()
    private lazy var uploadRepository: UploadRepository = UploadRepositoryImpl()
    
    init() {
        getProfile()
        updateUser()
    }
    
    func getProfile() {
        userRepository.getUserProfile()
            .subscribe { [weak self] user in
                self?.output.name.accept(user.name)
                self?.output.profileImage.accept(user.profileImage ?? "")
            } onFailure: { error in
                print(error)
            }.disposed(by: disposeBag)
    }
    
    func uploadImage(image: UIImage) {
        uploadRepository.uploadImage(image: image)
            .subscribe { [weak self] data in
                self?.output.profileImage.accept(data)
            } onFailure: { error in
                print(error)
            }.disposed(by: disposeBag)
    }
    
    func updateUser() {
        input.tapComplete
            .withLatestFrom(Observable.combineLatest(
                output.name,
                output.profileImage
            ))
        .withUnretained(self)
        .flatMap {
            $0.0.userRepository.updateUser(userRequest: UserRequest(name: $0.1.0, profileImage: $0.1.1))
        }.subscribe { data in
            print("성공!")
            self.output.onSuccessEvent.accept(true)
        } onError: { error in
            print("에러!")
            self.output.onErrorEvent.accept("")
        }.disposed(by: disposeBag)
    }
}
