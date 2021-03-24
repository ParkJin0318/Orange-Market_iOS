//
//  RegisterViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/24.
//

import AsyncDisplayKit
import RxSwift

class RegisterViewController: ASDKViewController<ASDisplayNode> {
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    
    override init() {
        super.init(node: ASDisplayNode())
        self.setupNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.bind()
    }
}

extension RegisterViewController: ViewControllerType {
    
    func setupNode() {
        self.node.do { container in
            container.backgroundColor = .systemBackground
        }
    }
    
    func setupNavigationBar() { }
    
    func bind() { }
}
