//
//  PasswordViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/25.
//

import AsyncDisplayKit
import RxSwift
import MBProgressHUD

class PwViewController: ASDKViewController<InputContainerNode> {
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    var registerRequest: RegisterRequest!
    
    private lazy var nextButton = UIButton().then {
        $0.setAttributedTitle("다음".toAttributed(color: .label, ofSize: 16), for: .normal)
        $0.tintColor = .label
    }
    
    override init() {
        super.init(node: InputContainerNode())
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
    }
    
    private func presentNameView() {
        guard !node.inputField.text!.isEmpty else {
            MBProgressHUD.errorShow("빈칸 없이 입력해주세요", from: self.view)
            return
        }
        self.registerRequest.userPw = node.inputField.text
        
        let vc = NameViewController()
        vc.registerRequest = registerRequest
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PwViewController: ViewControllerType {

    func initNode() {
        self.node.do { container in
            container.backgroundColor = .systemBackground
            
            container.stepNode.attributedText = "STEP 2 OF 3".toAttributed(color: .gray, ofSize: 16)
            container.titleNode.attributedText = "비밀번호".toBoldAttributed(color: .label, ofSize: 18)
            container.inputField.placeholder = "비밀번호 입력"
            container.inputField.isSecureTextEntry = true
        }
    }
    
    func loadNode() { }
    
    func setupNavigationBar() {
        self.navigationItem.do {
            $0.title = "비밀번호"
            $0.rightBarButtonItems = [
                UIBarButtonItem(customView: nextButton)
            ]
        }
    }
    
    func bind() {
        // input
        nextButton
            .rx.tap
            .bind(onNext: presentNameView)
            .disposed(by: disposeBag)
    }
}
