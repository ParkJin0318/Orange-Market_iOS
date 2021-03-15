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
        self.node.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
