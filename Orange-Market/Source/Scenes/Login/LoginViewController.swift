//
//  LoginViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/12.
//

import AsyncDisplayKit
import RxSwift
import MBProgressHUD

class LoginViewController: ASDKViewController<LoginContainerNode> {
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    lazy var viewModel: LoginViewModel = LoginViewModel()

    override init() {
        super.init(node: LoginContainerNode())
        self.setupNode()
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
    }
    
    private func bind() {
        // Input
        node.idField
            .rx.text.orEmpty
            .bind(to: viewModel.input.idText)
            .disposed(by: disposeBag)
        
        node.passwordField
            .rx.text.orEmpty
            .bind(to: viewModel.input.passwordText)
            .disposed(by: disposeBag)
        
        node.loginNode
            .rx.tap
            .bind(to: viewModel.input.tapLogin)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.output.isEnabled
            .bind(onNext: { [weak self] value in
                guard let self = self else { return }
                
                self.node.loginNode.do {
                    $0.isEnabled = value
                    $0.backgroundColor = value ? .primaryColor() : .lightGray
                }
            }).disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .bind(onNext: { [weak self] value in
                guard let self = self else { return }
                
                if (value) {
                    let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
                    progressHUD.mode = .indeterminate
                    progressHUD.label.text = "로딩중"
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }).disposed(by: disposeBag)
        
        viewModel.output.isLogin
            .bind(onNext: { [weak self] value in
                guard let self = self else { return }
                
            }).disposed(by: disposeBag)
    }
}

extension LoginViewController {
    
    private func setupNode() {
        self.node.do {
            $0.backgroundColor = .systemBackground
            
            $0.imageNode.image = UIImage(named: "security")
            $0.descriptionNode.attributedText = "오렌지마켓은 아이디로 로그인해요.\n개인정보는 안전하게 보관되며\n어디에도 공개되지 않아요."
                .toAttributed(color: .label, ofSize: 16)
            $0.idField.placeholder = "아이디 입력"
            $0.passwordField.placeholder = "비밀번호 입력"
            $0.loginNode.setTitle("로그인", with: .boldSystemFont(ofSize: 18), with: .systemBackground, for: .normal)
            $0.guideNode.attributedText = "당근마켓은 처음인가요? 가입하기".toAttributed(color: .label, ofSize: 15)
        }
    }
    
    private func setupNavigationBar() {
        self.navigationController?.do {
            $0.isNavigationBarHidden = false
            $0.navigationBar.topItem?.title = "로그인"
            $0.navigationBar.barTintColor = .systemBackground
            $0.navigationBar.tintColor = .black
        }
    }
}
