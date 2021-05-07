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

class ProductDetailViewController: ASDKViewController<ProductDetailViewContainer> {
    
    lazy var disposeBag = DisposeBag()
    lazy var viewModel = ProductDetailViewModel()
    
    var idx: Int = -1
    
    var soldMessage: String? = nil
    
    private lazy var moreButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        $0.tintColor = .label
    }
    
    override init() {
        super.init(node: ProductDetailViewContainer())
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
    
    private func moveToEdit() {
        let vc = ProductAddViewController().then {
            $0.product = self.viewModel.output.product
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func likeProduct() {
        viewModel.likeProduct(idx: self.idx)
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
        }
    }
    
    func loadNode() { }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: moreButton)
        ]
    }
    
    func moreAlret() {
        let actions: [UIAlertController.AlertAction] = [
            .action(title: "\(soldMessage ?? "")로 변경"),
            .action(title: "게시글 수정"),
            .action(title: "삭제", style: .destructive),
            .action(title: "취소", style: .cancel)
        ]
        
        UIAlertController
            .present(in: self, title: "게시글", message: "게시글 상태 변경", style: .actionSheet, actions: actions)
            .withUnretained(self)
            .subscribe { owner, value in
                switch (value) {
                    case 0:
                        owner.viewModel.updateSold(idx: owner.idx)
                    case 1:
                        owner.moveToEdit()
                    case 2:
                        owner.viewModel.deleteProduct(idx: owner.idx)
                    default:
                        break
                }
            }.disposed(by: disposeBag)
    }
    
    func bind() {
        // input
        moreButton.rx.tap
            .withUnretained(self)
            .bind { $0.0.moreAlret() }
            .disposed(by: disposeBag)
        
        node.productBottomNode.likeNode
            .rx.tap
            .bind(onNext: likeProduct)
            .disposed(by: disposeBag)
            
        // output
        let productData = viewModel.output.productData.share()
        
        productData
            .map { $0.profileImage?.toUrl() }
            .bind(to: node.productScrollNode.profileNode.profileImageNode.rx.url)
            .disposed(by: disposeBag)
        
        productData
            .map { $0.name.toBoldAttributed(color: .black, ofSize: 14) }
            .bind(to: node.productScrollNode.profileNode.nameNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        productData
            .map { $0.location.toAttributed(color: .black, ofSize: 12) }
            .bind(to: node.productScrollNode.profileNode.locationNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        productData
            .map { $0.title.toBoldAttributed(color: .black, ofSize: 18) }
            .bind(to: node.productScrollNode.titleNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        productData
            .map { $0.createAt.toAttributed(color: .gray, ofSize: 14) }
            .bind(to: node.productScrollNode.dateNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        productData
            .map { $0.contents.toAttributed(color: .black, ofSize: 14) }
            .bind(to: node.productScrollNode.contentsNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        productData
            .map { "\($0.price)원".toAttributed(color: .black, ofSize: 16) }
            .bind(to: node.productBottomNode.priceNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        productData
            .map { $0.isSold ? "판매중" : "판매완료" }
            .withUnretained(self)
            .bind { $0.0.soldMessage = $0.1 }
            .disposed(by: disposeBag)
        
        productData
            .map { $0.isSold ? "판매완료" : "구매하기" }
            .withUnretained(self)
            .bind { $0.0.node.productBottomNode.buyNode.setAttributedTitle($0.1.toAttributed(color: .systemBackground, ofSize: 16), for: .normal) }
            .disposed(by: disposeBag)
        
        productData
            .map { $0.isSold ? UIColor.lightGray : UIColor.primaryColor() }
            .bind(to: node.productBottomNode.buyNode.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        viewModel.output.isLike
            .map { $0 ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart") }
            .bind(to: node.productBottomNode.likeNode.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.output.onReloadEvent
            .filter { $0 }
            .withUnretained(self)
            .bind { $0.0.node.productScrollNode.collectionNode.reloadData() }
            .disposed(by: disposeBag)
        
        viewModel.output.onMessageEvent
            .withUnretained(self)
            .bind { owner, value in
                MBProgressHUD.hide(for: owner.view, animated: true)
                MBProgressHUD.errorShow(value, from: owner.view)
            }.disposed(by: disposeBag)
        
        viewModel.output.onDeleteEvent
            .filter { $0 }
            .withUnretained(self)
            .bind { owner, value in
                owner.popViewController()
            }.disposed(by: disposeBag)
        
        viewModel.output.isMyProduct
            .bind(to: moreButton.rx.isHidden)
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


