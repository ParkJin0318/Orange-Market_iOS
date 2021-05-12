//
//  ProfileViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/23.
//

import AsyncDisplayKit
import RxSwift
import MBProgressHUD

class MyInfoEditViewController: ASDKViewController<MyInfoEditViewContainer> {
    
    var disposeBag = DisposeBag()
    var viewModel = MyInfoEditViewModel()
    
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
        
        
        
        self.bind()
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
    
    func loadNode() {
        
    }
    
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
    
    func bind() {
        // input
        closeButton
            .rx.tap
            .bind(onNext: popViewController)
            .disposed(by: disposeBag)
        
        completeButton
            .rx.tap
            .bind(to: viewModel.input.tapComplete)
            .disposed(by: disposeBag)
        
        node.nameField
            .rx.text.orEmpty
            .bind(to: viewModel.output.name)
            .disposed(by: disposeBag)
        
        node.addButton
            .rx.tap
            .bind(onNext: presentImagePicker)
            .disposed(by: disposeBag)
        
        // output
        viewModel.output.profileImage
            .map { $0.toUrl() }
            .bind(to: node.profileImageNode.rx.url)
            .disposed(by: disposeBag)
        
        viewModel.output.name
            .bind(to: node.nameField.rx.text.orEmpty)
            .disposed(by: disposeBag)
        
        viewModel.output.onSuccessEvent
            .filter { $0 }
            .withUnretained(self)
            .bind { owner, value in
                owner.popViewController()
            }.disposed(by: disposeBag)
        
        viewModel.output.onErrorEvent
            .withUnretained(self)
            .bind { owner, value in
                MBProgressHUD.hide(for: owner.view, animated: true)
                MBProgressHUD.successShow(value, from: owner.view)
                owner.popViewController()
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
        let image = info[.originalImage] as? UIImage
        viewModel.uploadImage(image: image!)
        dismiss(animated: true, completion: nil)
    }
}
