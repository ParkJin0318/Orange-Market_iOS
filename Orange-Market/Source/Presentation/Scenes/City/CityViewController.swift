//
//  CityViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import AsyncDisplayKit
import RxSwift

class CityViewContoller: ASDKViewController<ASDisplayNode> {
    
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
        self.setupNavigationBar()
        self.bind()
    }
}

extension CityViewContoller: ViewControllerType {
    
    func setupNode() {
        self.node.do { container in
            container.backgroundColor = .systemBackground
        }
    }
    
    func setupNavigationBar() {
        self.navigationItem.do {
            $0.title = "지역생활"
        }
    }
    
    func bind() { }
}
