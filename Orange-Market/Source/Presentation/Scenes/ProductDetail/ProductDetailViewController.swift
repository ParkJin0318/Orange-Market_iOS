//
//  ProductDetailViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/17.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

class ProductDetailViewController: ASDKViewController<ProductDetailContainer> {
    
    lazy var disposeBag = DisposeBag()
    private lazy var viewModel = ProductDetailViewModel()
    
    var idx: Int = -1
    
    override init() {
        super.init(node: ProductDetailContainer())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNode()
        self.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getProduct(idx: idx)
    }
    
    private func setupNode() {
        self.node.do {
            $0.automaticallyManagesSubnodes = true
            $0.backgroundColor = .systemBackground
            
            $0.collectionNode.delegate = self
            $0.collectionNode.dataSource = self
        }
    }
    
    private func bind() {
        viewModel.output.productData
            .bind { [weak self] value in
                guard let self = self else { return }
                
                self.node.do {
                    $0.collectionNode.reloadData()
                    $0.profileImageNode.url = URL(string: HOST + "images/" + (value.profileImage ?? ""))
                    $0.nameNode.attributedText = value.name.toBoldAttributed(color: .black, ofSize: 14)
                    $0.locationNode.attributedText = value.location.toAttributed(color: .black, ofSize: 12)
                }
            }.disposed(by: disposeBag)
    }
}

extension ProductDetailViewController: ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(
            min: CGSize(width: 0, height: 0),
            max: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        )
    }
}

extension ProductDetailViewController: ASCollectionDataSource {
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.imageList.count
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] in
            let item = self?.viewModel.output.imageList[indexPath.row]
            let cell = ProductImageCell().then {
                $0.setupNode(url: item!)
                $0.imageNode.style.preferredSize = CGSize(width: width, height: 300)
            }
            return cell
        }
    }
}


