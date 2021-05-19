//
//  LocalListViewContoller.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import AsyncDisplayKit
import RxSwift

class LocalListViewContoller: ASDKViewController<ASDisplayNode> {
    
    lazy var disposeBag = DisposeBag()
    
    override init() {
        super.init(node: ASDisplayNode())
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
}

extension LocalListViewContoller: ViewControllerType {
    
    func initNode() {
        self.node.do { container in
            container.backgroundColor = .systemBackground
        }
    }
    
    func loadNode() { }
    
    func setupNavigationBar() {
        self.navigationItem.do {
            $0.title = "지역생활"
        }
    }
    
    func bind() { }
}
