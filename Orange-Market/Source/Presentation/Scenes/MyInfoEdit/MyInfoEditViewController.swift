//
//  ProfileViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/23.
//

import AsyncDisplayKit
import ReactorKit
import RxSwift
import MBProgressHUD

class MyInfoEditViewController: ASDKViewController<MyInfoEditViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    
    lazy var userRequest = UserRequest()
    
    lazy var closeButton = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.label, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
    lazy var completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.label, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
    override init() {
        super.init(node: MyInfoEditViewContainer())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNode()
        reactor = MyInfoEditViewReactor()
        
        if let reactor = self.reactor {
            Observable.just(.fetchUserInfo)
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
    
    private func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyInfoEditViewController: ViewControllerType {
    
    func initNode() {
        self.node.do { container in
            container.automaticallyManagesSubnodes = true
            container.backgroundColor = .systemBackground
        }
    }
    
    func loadNode() { }
    
    func setupNavigationBar() {
        self.navigationItem.do {
            $0.title = "프로필 수정"
            
            $0.leftBarButtonItems = [
                UIBarButtonItem(customView: closeButton)
            ]
            $0.rightBarButtonItems = [
                UIBarButtonItem(customView: completeButton)
            ]
        }
    }
    
    func bind(reactor: MyInfoEditViewReactor) {
        // Action
        closeButton.rx.tap
            .bind(onNext: popViewController)
            .disposed(by: disposeBag)

        completeButton.rx.tap
            .map { .updateUerInfo(self.userRequest) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        node.nameField.rx.text.orEmpty
            .map { .name($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        node.addButton.rx.tap
            .bind(onNext: presentImagePicker)
            .disposed(by: disposeBag)
        
        // State
        let userData = reactor.state
            .filter { $0.userRequest != nil }
            .map { $0.userRequest! }
            .share()
        
        userData
            .map { $0.profileImage?.toUrl() }
            .bind(to: node.profileImageNode.rx.url)
            .disposed(by: disposeBag)

        userData
            .map { $0.name ?? "" }
            .bind(to: node.nameField.rx.text.orEmpty)
            .disposed(by: disposeBag)
        
        userData
            .withUnretained(self)
            .bind { owner, value in
                owner.userRequest = value
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.isSuccessUploadImage }
            .distinctUntilChanged()
            .filter { $0 != nil}
            .withUnretained(self)
            .bind { owner, value in
                
                Observable.just(.image(value!))
                    .bind(to: reactor.action)
                    .disposed(by: owner.disposeBag)
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.isSuccessUserInfo }
            .distinctUntilChanged()
            .filter { $0 }
            .withUnretained(self)
            .bind { $0.0.popViewController() }
            .disposed(by: disposeBag)
            
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, value in
                if (value) {
                    MBProgressHUD.loading(from: owner.view)
                } else {
                    MBProgressHUD.hide(for: owner.view, animated: true)
                }
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .filter { $0 != nil }
            .withUnretained(self)
            .bind { owner, value in
                MBProgressHUD.errorShow(value!, from: owner.view)
            }.disposed(by: disposeBag)
    }
}

extension MyInfoEditViewController: UINavigationControllerDelegate & UIImagePickerControllerDelegate {
    
    private func presentImagePicker() {
        let imagePickerController = UIImagePickerController().then {
            $0.delegate = self
            $0.allowsEditing = true
            $0.sourceType = .photoLibrary
        }
        
        self.present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let reactor = self.reactor, let image = info[.originalImage] as? UIImage {
            Observable.just(.uploadImage(image))
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
        dismiss(animated: true, completion: nil)
    }
}
