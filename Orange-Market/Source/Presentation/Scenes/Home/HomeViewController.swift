//
//  HomeViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import AsyncDisplayKit
import RxSwift

class HomeViewController: ASDKViewController<ASDisplayNode> {
    
    lazy var disposeBag = DisposeBag()
    lazy var viewModel = HomeViewModel()
    
    override init() {
        super.init(node: StartContainerNode())
        self.node.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
    }
    
    private func bind() {
        viewModel.output.city
            .bind(onNext: { [weak self] value in
                self?.navigationController?.navigationBar.topItem?.title = value
            }).disposed(by: disposeBag)
    }
}
