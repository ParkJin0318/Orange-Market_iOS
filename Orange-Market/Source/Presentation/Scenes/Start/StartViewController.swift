//
//  ViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/12.
//

import Then
import RxSwift
import AsyncDisplayKit
import RxTexture2

class StartViewController: ASDKViewController<StartContainerNode> {
    
    lazy var disposeBag = DisposeBag()
    
    override init() {
        super.init(node: StartContainerNode())
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
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension StartViewController {
    
    private func setupNode() {
        self.node.do {
            $0.backgroundColor = .systemBackground
            
            $0.titleNode.attributedText = "오렌지마켓".toFontAttributed(
                color: .primaryColor(),
                fontName: JuaRegular,
                ofSize: 50
            )
            $0.imageNode.image = UIImage(named: "world")
            
            $0.subheadNode.attributedText = "지역별 중고 직거래 오렌지마켓".toBoldAttributed(
                color: .black,
                ofSize: 20
            )
            $0.descriptionNode.attributedText = "오렌지마켓은 지역별 직거래 마켓이에요.\n내 지역을 설정하고 시작해보세요!".toCenterAttributed(
                color: .darkGray,
                ofSize: 18
            )
            $0.startNode.setTitle(
                "내 지역 설정하고 시작하기",
                with: .boldSystemFont(ofSize: 18),
                with: .white,
                for: .normal
            )
            $0.startNode.backgroundColor = .primaryColor()
        }
    }
    
    private func bind() {
        node.startNode
            .rx.tap
            .bind(onNext: presentLoginView)
            .disposed(by: disposeBag)
    }
    
    private func presentLoginView() {
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
}
