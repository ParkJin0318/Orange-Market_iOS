//
//  RegisterViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/26.
//

import AsyncDisplayKit
import RxSwift
import MBProgressHUD
import ReactorKit

class RegisterViewController: ASDKViewController<RegisterViewContainer> & View {
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    
    var registerRequest: RegisterRequest!
    var locationManager:CLLocationManager!
    
    private lazy var completeButton = UIButton().then {
        $0.setAttributedTitle("완료".toAttributed(color: .label, ofSize: 16), for: .normal)
        $0.tintColor = .label
    }
    
    override init() {
        super.init(node: RegisterViewContainer())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNode()
        reactor = RegisterViewReactor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
    
    private func presentLoginView() {
        let controllers = self.navigationController?.viewControllers
        for vc in controllers! {
            self.navigationController?.popToViewController(vc, animated: true)
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

extension RegisterViewController: ViewControllerType {
    
    func initNode() {
        self.node.do { container in
            container.backgroundColor = .systemBackground
            
            container.idTitleNode.attributedText = "아이디".toBoldAttributed(color: .label, ofSize: 16)
            container.nameTitleNode.attributedText = "이름".toBoldAttributed(color: .label, ofSize: 16)
            container.locationTitleNode.attributedText = "위치 정보".toBoldAttributed(color: .label, ofSize: 16)
        }
    }
    
    func loadNode() {
        let request = Observable.just(registerRequest)
            .filter { $0 != nil }
            .share()
        
        self.node.do { container in
            request.map { $0?.userId?.toAttributed(color: .label, ofSize: 14) }
                .bind(to: container.idNode.rx.attributedText)
                .disposed(by: disposeBag)
            
            request.map { $0?.name?.toAttributed(color: .label, ofSize: 14) }
                .bind(to: container.nameNode.rx.attributedText)
                .disposed(by: disposeBag)
            
            request.map { $0?.location?.toAttributed(color: .label, ofSize: 14) }
                .bind(to: container.locationNode.rx.attributedText)
                .disposed(by: disposeBag)
        }
    }
    
    func setupNavigationBar() {
        self.navigationItem.do {
            $0.title = "회원가입"
            $0.rightBarButtonItems = [
                UIBarButtonItem(customView: completeButton)
            ]
        }
    }
    
    func bind(reactor: RegisterViewReactor) {
        // Action
        completeButton.rx.tap
            .withUnretained(self)
            .map { .register($0.0.registerRequest) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        node.addButton
            .rx.tap
            .bind(onNext: presentImagePicker)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.isSuccessRegister }
            .filter { $0 }
            .withUnretained(self)
            .bind { $0.0.presentLoginView() }
            .disposed(by: disposeBag)
        
        let isSuccessUploadImage = reactor.state
            .map { $0.isSuccessUploadImage }
            .share()
        
        isSuccessUploadImage
            .filter { $0 != nil }
            .map { $0!.toUrl() }
            .bind(to: node.profileImageNode.rx.url)
            .disposed(by: disposeBag)
        
        isSuccessUploadImage
            .withUnretained(self)
            .bind { $0.0.registerRequest.profileImage = $0.1 }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: view.rx.loading)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: view.rx.error)
            .disposed(by: disposeBag)
    }
}

extension RegisterViewController: UINavigationControllerDelegate & UIImagePickerControllerDelegate {
    
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
            Observable.just(image)
                .map { .uploadImage($0) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
        dismiss(animated: true, completion: nil)
    }
}
