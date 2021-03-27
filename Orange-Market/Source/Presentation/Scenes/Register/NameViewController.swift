//
//  NameViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/25.
//

import AsyncDisplayKit
import RxSwift
import MBProgressHUD

class NameViewController: ASDKViewController<InputContainerNode> {
    
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
    
    private func presentRegisterView() {
        guard !node.inputField.text!.isEmpty else {
            MBProgressHUD.errorShow("빈칸 없이 입력해주세요", from: self.view)
            return
        }
        self.registerRequest.name = node.inputField.text
        
        let vc = RegisterViewController()
        vc.registerRequest = registerRequest
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NameViewController: ViewControllerType {
    
    func initNode() {
        self.node.do { container in
            container.backgroundColor = .systemBackground
            
            container.stepNode.attributedText = "STEP 3 OF 3".toAttributed(color: .gray, ofSize: 16)
            container.titleNode.attributedText = "이름".toBoldAttributed(color: .label, ofSize: 18)
            container.inputField.placeholder = "이름 입력"
        }
    }
    
    func loadNode() { }
    
    func setupNavigationBar() {
        self.navigationItem.do {
            $0.title = "이름"
            $0.rightBarButtonItems = [
                UIBarButtonItem(customView: nextButton)
            ]
        }
    }
    
    func bind() {
        // input
        nextButton
            .rx.tap
            .bind(onNext: presentRegisterView)
            .disposed(by: disposeBag)
    }
}
