//
//  RegisterViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/26.
//

import AsyncDisplayKit
import RxSwift

class RegisterViewController: ASDKViewController<RegisterContainerNode> {
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    lazy var viewModel: RegisterViewModel = RegisterViewModel()
    
    var registerRequest: RegisterRequest!
    var locationManager:CLLocationManager!
    
    private lazy var completeButton = UIButton().then {
        $0.setAttributedTitle("완료".toAttributed(color: .label, ofSize: 16), for: .normal)
        $0.tintColor = .label
    }
    
    override init() {
        super.init(node: RegisterContainerNode())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
        self.loadNode()
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
        self.node.do { container in
            container.idNode.attributedText = registerRequest.userId?.toAttributed(color: .label, ofSize: 14)
            container.nameNode.attributedText = registerRequest.name?.toAttributed(color: .label, ofSize: 14)
            container.locationNode.attributedText = registerRequest.location?.toAttributed(color: .label, ofSize: 14)
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
    
    func bind() {
        // input
        completeButton
            .rx.tap
            .bind(onNext: viewModel.register)
            .disposed(by: disposeBag)
        
        node.addButton
            .rx.tap
            .bind(onNext: presentImagePicker)
            .disposed(by: disposeBag)
        
        // output
        viewModel.output.imageUrl
            .map { $0.toUrl() }
            .bind(to: node.profileImageNode.rx.url)
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
        let image = info[.originalImage] as? UIImage
        viewModel.uploadImage(image: image!)
        dismiss(animated: true, completion: nil)
    }
}
