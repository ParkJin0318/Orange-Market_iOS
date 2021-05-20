//
//  LocalPostDetailViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/20.
//

import AsyncDisplayKit
import ReactorKit

class LocalPostDetailViewController: ASDKViewController<LocalPostDetailViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    
    var idx: Int = -1
    
    override init() {
        super.init(node: LocalPostDetailViewContainer())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNode()
        reactor = LocalPostDetailViewReactor()
        
        Observable.just(.fetchLocalPost(idx))
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
}

extension LocalPostDetailViewController: ViewControllerType {
    
    func initNode() {
        self.node.do {
            $0.automaticallyManagesSubnodes = true
            $0.backgroundColor = .systemBackground
        }
    }
    
    func loadNode() { }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
    }
    
    func bind(reactor: LocalPostDetailViewReactor) {
        // State
        reactor.state.map { $0.localPost }
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: node.rx.post)
            .disposed(by: disposeBag)
    }
}
