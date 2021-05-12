//
//  SalesListViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/04.
//

import AsyncDisplayKit
import RxSwift

class SalesListViewController: ASDKViewController<SalesListViewContainer> {
    
    lazy var disposeBag = DisposeBag()
    lazy var viewModel = SalesListViewModel()
    
    var type: ProductType!
    
    override init() {
        super.init(node: SalesListViewContainer())
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
        viewModel.getProducts(type: type)
    }
}

extension SalesListViewController: ViewControllerType {
    
    func initNode() {
        self.node.do {
            $0.automaticallyManagesSubnodes = true
            $0.backgroundColor = .systemBackground
            
            $0.collectionNode.delegate = self
            $0.collectionNode.dataSource = self
        }
    }
    
    func loadNode() { }
    
    func setupNavigationBar() {
        switch (type!) {
        case .sales:
            self.navigationItem.title = "판매내역"
        case .like:
            self.navigationItem.title = "관심목록"
        default:
            break
        }
        self.navigationController?.navigationBar.tintColor = .label
    }
    
    func bind() {
        viewModel.output.onReloadEvent
            .withUnretained(self)
            .bind(onNext: { owner, value in
                owner.node.collectionNode.reloadData()
            }).disposed(by: disposeBag)
    }
}

extension SalesListViewController: ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(
            min: CGSize(width: width, height: 0),
            max: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        )
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.output.productList[indexPath.row]
        
        let vc = ProductDetailViewController().then {
            $0.idx = item.idx
            $0.hidesBottomBarWhenPushed = true
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SalesListViewController: ASCollectionDataSource {
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
            
            if (item?.isSold == true) {
                cell.alpha = 0.5
            }
            return cell
        }
    }
}
