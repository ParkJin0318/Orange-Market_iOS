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
        self.navigationController?.navigationBar.tintColor = .label
        // self.setupNavigationBar()
        self.setupNode()
        self.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getProduct(idx: idx)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.do {
            $0.navigationBar.setBackgroundImage(UIImage(), for: .default)
            $0.navigationBar.shadowImage = UIImage()
            $0.navigationBar.isTranslucent = true
            $0.navigationBar.tintColor = .white
            $0.view.backgroundColor = .clear
        }
    }
    
    private func setupNode() {
        self.node.do {
            $0.backgroundColor = .systemBackground
            
            $0.collectionNode.delegate = self
            $0.collectionNode.dataSource = self
            
            $0.productBottomNode.buyNode.setTitle("구매하기", with: .none, with: .white, for: .normal)
        }
    }
    
    private func bind() {
        // output
        let productData = viewModel.output.productData.share()
        
        productData
            .map { $0.profileImage?.toUrl() }
            .bind(to: node.profileNode.profileImageNode.rx.url)
            .disposed(by: disposeBag)
        
        productData
            .map { $0.name.toBoldAttributed(color: .black, ofSize: 14) }
            .bind(to: node.profileNode.nameNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        productData
            .map { $0.location.toAttributed(color: .black, ofSize: 12) }
            .bind(to: node.profileNode.locationNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        productData
            .map { $0.title.toBoldAttributed(color: .black, ofSize: 18) }
            .bind(to: node.contentNode.titleNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        productData
            .map { $0.createAt.toAttributed(color: .gray, ofSize: 14) }
            .bind(to: node.contentNode.dateNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        productData
            .map { $0.contents.toAttributed(color: .black, ofSize: 14) }
            .bind(to: node.contentNode.contentsNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        productData
            .map { "\($0.price)원".toAttributed(color: .black, ofSize: 16) }
            .bind(to: node.productBottomNode.priceNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.output.isReloadData
            .filter { $0 }
            .bind { [weak self] value in
                self?.node.collectionNode.reloadData()
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


