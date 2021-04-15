//
//  ProductDetailViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/17.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa
import MBProgressHUD

class ProductDetailViewController: ASDKViewController<ProductDetailContainerNode> {
    
    lazy var disposeBag = DisposeBag()
    lazy var viewModel = ProductDetailViewModel()
    
    var idx: Int = -1
    
    private lazy var removeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "trash"), for: .normal)
        $0.tintColor = .label
    }
    
    override init() {
        super.init(node: ProductDetailContainerNode())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.loadNode()
        self.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getProduct(idx: idx)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func deleteProduct() {
        viewModel.deleteProduct(idx: idx)
    }
}

extension ProductDetailViewController: ViewControllerType {
    
    func initNode() {
        self.node.do { container in
            container.backgroundColor = .systemBackground
            
            container.productScrollNode.do {
                $0.collectionNode.delegate = self
                $0.collectionNode.dataSource = self
            }
            container.productBottomNode.buyNode.setTitle("구매하기", with: .none, with: .white, for: .normal)
        }
    }
    
    func loadNode() { }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: removeButton)
        ]
    }
    
    func bind() {
        // input
        removeButton.rx.tap
            .bind(onNext: deleteProduct)
            .disposed(by: disposeBag)
            
        // output
        let productData = viewModel.output.productData.share()
        
        node.productScrollNode.do { node in
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
        }
        
        productData
            .map { "\($0.price)원".toAttributed(color: .black, ofSize: 16) }
            .bind(to: node.productBottomNode.priceNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        viewModel.output.onReloadEvent
            .filter { $0 }
            .withUnretained(self)
            .bind { $0.0.node.productScrollNode.collectionNode.reloadData() }
            .disposed(by: disposeBag)
        
        viewModel.output.onFailureEvent
            .withUnretained(self)
            .bind { owner, value in
                MBProgressHUD.hide(for: owner.view, animated: true)
                MBProgressHUD.errorShow(value, from: owner.view)
            }.disposed(by: disposeBag)
        
        viewModel.output.onDeleteEvent
            .withUnretained(self)
            .bind { owner, value in
                owner.popViewController()
            }.disposed(by: disposeBag)
        
        viewModel.output.isDeleteHideen
            .bind(to: removeButton.rx.isHidden)
            .disposed(by: disposeBag)
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


