//
//  ProductDetailViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/17.
//

import AsyncDisplayKit
import RxDataSources_Texture
import ReactorKit
import RxSwift
import RxCocoa
import MBProgressHUD

class ProductDetailViewController: ASDKViewController<ProductDetailViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    
    var idx: Int = -1
    var product: Product? = nil
    var soldMessage: String? = nil
    
    private lazy var moreButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        $0.tintColor = .label
    }
    
    let rxDataSource = RxASCollectionSectionedAnimatedDataSource<ProductImageListSection>(
        configureCellBlock: { _, _, _, item in
            switch item {
                case .image(let image):
                    return { ProductImageCell(image: image) }
            }
    })
    
    override init() {
        super.init(node: ProductDetailViewContainer())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(œcoder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNode()
        reactor = ProductDetailViewReactor()
        
        node.productScrollNode.collectionNode
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
        
        Observable.just(.fetchProduct(idx))
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
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
        self.node.do {
            $0.backgroundColor = .systemBackground
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
            .bind(onNext: moreAlret)
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
            .map { $0.map { ProductImageListSectionItem.image($0) } }
            .map { [ProductImageListSection.image(images: $0)] }
            .bind(to: node.productScrollNode.collectionNode.rx.items(dataSource: rxDataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLikeProduct }
            .map { $0 ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart") }
            .bind(to: node.productBottomNode.likeNode.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isMyProduct }
            .bind(to: moreButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isSuccessDelete }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(to: self.rx.pop)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: view.rx.loading)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: view.rx.error)
            .disposed(by: disposeBag)
    }
}

extension ProductDetailViewController: ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(
            min: CGSize(width: width, height: 300),
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
