//
//  MyInfoViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/23.
//

import AsyncDisplayKit
import RxSwift

class MyInfoViewController: ASDKViewController<MyInfoViewContainer> {
    
    lazy var viewModel = MyInfoViewModel()
    lazy var disposeBag = DisposeBag()
    
    override init() {
        super.init(node: MyInfoViewContainer())
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
    
    func presentSalesListView() {
        self.navigationController?.pushViewController(SalesListViewController(), animated: true)
    }
}

extension MyInfoViewController: ViewControllerType {
    
    func initNode() {
        self.node.do { container in
            container.backgroundColor = .systemBackground
            container.profileOpenNode.setAttributedTitle("프로필 보기".toAttributed(color: .label, ofSize: 12), for: .normal)
            container.profileNode.profileImageNode.style.preferredSize = CGSize(width: 70, height: 70)
            container.profileNode.profileImageNode.cornerRadius = 70 / 2
            container.profileNode.viewNode.isHidden = true
            
            container.salesNode.iconNode.image = UIImage(named: "receipt")
            container.salesNode.textNode.attributedText = "판매 내역".toAttributed(color: .label, ofSize: 12)
            
            container.buyNode.iconNode.image = UIImage(named: "basket")
            container.buyNode.textNode.attributedText = "구매 내역".toAttributed(color: .label, ofSize: 12)
            
            container.attentionNode.iconNode.image = UIImage(named: "heart")
            container.attentionNode.textNode.attributedText = "관심 목록".toAttributed(color: .label, ofSize: 12)
        }
    }
    
    func loadNode() { }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.topItem?.title = "나의 오렌지"
    }
    
    func bind() {
        node.salesNode
            .rx.tap
            .bind(onNext: presentSalesListView)
            .disposed(by: disposeBag)
        
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
