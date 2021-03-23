//
//  MyInfoViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/23.
//

import AsyncDisplayKit
import RxSwift

class MyInfoViewController: ASDKViewController<MyInfoContainer> {
    
    lazy var viewModel = MyInfoViewModel()
    lazy var disposeBag = DisposeBag()
    
    override init() {
        super.init(node: MyInfoContainer())
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
    
    private func setupNode() {
        self.node.do { container in
            container.backgroundColor = .systemBackground
            container.profileOpenNode.setTitle("프로필 보기", with: .none, with: .none, for: .normal)
            container.profileNode.profileImageNode.style.preferredSize = CGSize(width: 70, height: 70)
            container.profileNode.profileImageNode.cornerRadius = 70 / 2
            container.profileNode.viewNode.isHidden = true
        }
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = "나의 오렌지"
    }
    
    private func bind() {
        let userData = viewModel.output.userData.share()
        
        userData.map { $0.profileImage?.toUrl() }
            .bind(to: node.profileNode.profileImageNode.rx.url)
            .disposed(by: disposeBag)
        
        userData.map { $0.name.toAttributed(color: .label, ofSize: 16) }
            .bind(to: node.profileNode.nameNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        userData.map { $0.location.toAttributed(color: .gray, ofSize: 14) }
            .bind(to: node.profileNode.locationNode.rx.attributedText)
            .disposed(by: disposeBag)
    }
}
