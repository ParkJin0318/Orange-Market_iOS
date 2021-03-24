//
//  SplashViewContoller.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import AsyncDisplayKit
import RxSwift

class SplashViewContoller: ASDKViewController<ASDisplayNode> {
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.window!.layer.add(CATransition().then {
            $0.duration = 0.5
            $0.type = .fade
            $0.subtype = .fromBottom
        }, forKey: kCATransition)
        
        if (AuthController.getInstance().getToken().isEmpty) {
            let vc = ASNavigationController(rootViewController: StartViewController()).then {
                $0.modalPresentationStyle = .fullScreen
                $0.modalTransitionStyle = .crossDissolve
            }
            self.present(vc, animated: true)
        } else {
            let vc = TabBarController().then {
                $0.modalPresentationStyle = .fullScreen
                $0.modalTransitionStyle = .crossDissolve
            }
            self.present(vc, animated: true)
        }
    }
}

extension SplashViewContoller: ViewControllerType {
    
    func setupNode() {
        self.node.do {
            $0.automaticallyManagesSubnodes = true
            $0.backgroundColor = .systemBackground
        }
    }
    
    func setupNavigationBar() { }
    
    func bind() { }
}
