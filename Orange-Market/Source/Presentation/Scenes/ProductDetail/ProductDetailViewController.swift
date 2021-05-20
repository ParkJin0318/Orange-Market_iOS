//
//  ProductDetailViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/17.
//

import AsyncDisplayKit
import ReactorKit
import RxSwift
import RxCocoa
import MBProgressHUD

class ProductDetailViewController: ASDKViewController<ProductDetailViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    
    lazy var images: [String] = []
    var soldMessage: String? = nil
    
    var idx: Int = -1
    var product: Product? = nil
    
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
        self.loadNode()
        reactor = ProductDetailViewReactor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
        
        if let reactor = self.reactor {
            Observable.just(.fetchProduct(idx))
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func moveToEdit() {
        let vc = ProductAddViewController().then {
            $0.product = self.product
        }
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    func loadNode() {
        self.node.do { container in
            
            container.productScrollNode.do {
                $0.collectionNode.view.decelerationRate = .fast
                $0.collectionNode.view.showsHorizontalScrollIndicator = false
            }
        }
    }
    
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
                        Observable.just(.updateSold(owner.idx))
                            .bind(to: owner.reactor!.action)
                            .disposed(by: owner.disposeBag)
                    case 1:
                        owner.moveToEdit()
                    case 2:
                        Observable.just(.deleteProduct(owner.idx))
                            .bind(to: owner.reactor!.action)
                            .disposed(by: owner.disposeBag)
                    default:
                        break
                }
            }.disposed(by: disposeBag)
    }
    
    func bind(reactor: ProductDetailViewReactor) {
        // Action
        moreButton.rx.tap
            .withUnretained(self)
            .bind { $0.0.moreAlret() }
            .disposed(by: disposeBag)
        
        node.productBottomNode.likeNode.rx.tap
            .map { .likeProduct(self.idx) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        let productData = reactor.state
            .filter { $0.product != nil }
            .map { $0.product! }
            .share()
        
        productData
            .bind(to: node.productScrollNode.rx.product)
            .disposed(by: disposeBag)
        
        productData
            .bind(to: node.productBottomNode.rx.product)
            .disposed(by: disposeBag)
        
        productData
            .withUnretained(self)
            .bind { $0.0.product = $0.1 }
            .disposed(by: disposeBag)
    
        productData
            .map { $0.isSold ? "판매중" : "판매완료" }
            .withUnretained(self)
            .bind { $0.0.soldMessage = $0.1 }
            .disposed(by: disposeBag)
        
        productData.map { $0.images }
            .withUnretained(self)
            .filter { !$0.1.elementsEqual($0.0.images) }
            .bind { owner, value in
                owner.images = value
                owner.node.productScrollNode.collectionNode.reloadData()
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.isLikeProduct }
            .map { $0 ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart") }
            .bind(to: node.productBottomNode.likeNode.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isMyProduct }
            .bind(to: moreButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isSuccessDelete }
            .filter { $0 }
            .withUnretained(self)
            .bind { $0.0.popViewController() }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, value in
                if (value) {
                    MBProgressHUD.loading(from: owner.view)
                } else {
                    MBProgressHUD.hide(for: owner.view, animated: true)
                }
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .filter { $0 != nil }
            .withUnretained(self)
            .bind { owner, value in
                MBProgressHUD.errorShow(value!, from: owner.view)
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
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let cellWidth = width + 10
        
        var offset = targetContentOffset.pointee
        let index = offset.x / cellWidth
        var roundedIndex = round(index)
        
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else {
            roundedIndex = ceil(index)
        }
        
        offset = CGPoint(x: roundedIndex * cellWidth, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}

extension ProductDetailViewController: ASCollectionDataSource {
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] in
            let item = self?.images[indexPath.row]
            let cell = ProductImageCell().then {
                $0.setupNode(url: item!)
                $0.imageNode.style.preferredSize = CGSize(width: width, height: 300)
            }
            return cell
        }
    }
}


