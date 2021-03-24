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
    
    private func presentHomeView() {
        self.present(TabBarController().then {
            $0.modalPresentationStyle = .fullScreen
            $0.modalTransitionStyle = .crossDissolve
        }, animated: true)
    }
    
    private func presentRegisterView() {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
}

extension LoginViewController: ViewControllerType {
    
    func setupNode() {
        self.node.do {
            $0.backgroundColor = .systemBackground
            
            $0.imageNode.image = UIImage(named: "security")
            $0.descriptionNode.attributedText =
                "오렌지마켓은 아이디로 로그인해요.\n개인정보는 안전하게 보관되며\n어디에도 공개되지 않아요." .toAttributed(color: .label, ofSize: 16)
            $0.idField.placeholder = "아이디 입력"
            $0.passwordField.placeholder = "비밀번호 입력"
            $0.loginNode.setTitle("로그인", with: .boldSystemFont(ofSize: 18), with: .systemBackground, for: .normal)
            $0.guideNode.attributedText = "오렌지마켓은 처음인가요?".toAttributed(color: .label, ofSize: 15)
            $0.registerNode.setAttributedTitle("가입하기".toBoldAttributed(color: .label, ofSize: 15), for: .normal)
        }
    }
    
    func setupNavigationBar() {
        self.navigationController?.do {
            $0.isNavigationBarHidden = false
            $0.navigationBar.topItem?.title = "로그인"
            $0.navigationBar.barTintColor = .systemBackground
            $0.navigationBar.tintColor = .black
        }
    }
    
    func bind() {
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
        
        node.registerNode
            .rx.tap
            .bind(onNext: presentRegisterView)
            .disposed(by: disposeBag)
        
        // Output
        let isEnabled = viewModel.output.isEnabled.share()
        
        isEnabled
            .bind(to: node.loginNode.rx.isEnabled)
            .disposed(by: disposeBag)
        
        isEnabled
            .map { $0 ? UIColor.primaryColor() : UIColor.lightGray }
            .bind(to: node.loginNode.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .filter { $0 }
            .withUnretained(self)
            .bind { MBProgressHUD.loading(from: $0.0.view) }
            .disposed(by: disposeBag)
        
        viewModel.output.isLogin
            .withUnretained(self)
            .bind { owner, value in
                if (value) {
                    MBProgressHUD.hide(for: owner.view, animated: true)
                    MBProgressHUD.successShow("로그인 성공!", from: owner.view)
                    owner.presentHomeView()
                } else {
                    MBProgressHUD.hide(for: owner.view, animated: true)
                    MBProgressHUD.errorShow("로그인 실패", from: owner.view)
                }
            }.disposed(by: disposeBag)
    }
}
