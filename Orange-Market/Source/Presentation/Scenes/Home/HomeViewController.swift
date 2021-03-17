//
//  HomeViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import AsyncDisplayKit
import RxSwift

class HomeViewController: ASDKViewController<HomeContainer> {
    
    lazy var disposeBag = DisposeBag()
    lazy var viewModel = HomeViewModel()
    
    private lazy var writeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        $0.tintColor = .label
    }
    
    override init() {
        super.init(node: HomeContainer())
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
    
    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: writeButton)
        ]
    }
    
    private func bind() {
        // input
        writeButton.rx.tap
            .bind(onNext: self.presentProductAddView)
            .disposed(by: disposeBag)
        
        // output
        viewModel.output.city
            .bind(onNext: { [weak self] value in
                guard let self = self else { return }
                
                self.navigationController?.navigationBar.topItem?.title = value
                self.node.collectionNode.reloadData()
            }).disposed(by: disposeBag)
    }
    
    private func presentProductAddView() {
        self.navigationController?.pushViewController(ProductAddViewController().then {
            $0.hidesBottomBarWhenPushed = true
        }, animated: true)
    }
    
    private func setupNode() {
        self.node.do {
            $0.automaticallyManagesSubnodes = true
            $0.backgroundColor = .systemBackground
            
            $0.collectionNode.delegate = self
            $0.collectionNode.dataSource = self
        }
    }
}

extension HomeViewController: ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(
            min: CGSize(width: width, height: 0),
            max: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        )
    }
}

extension HomeViewController: ASCollectionDataSource {
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.productList.count
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] in
            let item = self?.viewModel.output.productList[indexPath.row]
            let cell = ProductCell()
            cell.setupNode(product: item!)
            return cell
        }
    }
}
