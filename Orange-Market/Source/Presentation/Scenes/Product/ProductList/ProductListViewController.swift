//
//  ProductListViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import AsyncDisplayKit
import ReactorKit
import RxSwift
import MBProgressHUD
import Floaty

class ProductListViewController: ASDKViewController<ProductListViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    
    lazy var products: [Product] = []
    var type: ProductType = .none
    
    lazy var floating = Floaty().then {
        $0.buttonColor = .primaryColor()
        $0.plusColor = .white
        $0.selectedColor = .white
        
        $0.addItem(item: productButton)
        $0.addItem(item: localPostButton)
    }
    
    lazy var productButton = FloatyItem().then {
        $0.title = "중고거래"
        $0.icon = UIImage(systemName: "pencil")
        $0.iconTintColor = .white
        $0.buttonColor = .primaryColor()
    }
    
    lazy var localPostButton = FloatyItem().then {
        $0.title = "지역생활"
        $0.icon = UIImage(systemName: "doc.plaintext")
        $0.iconTintColor = .white
        $0.buttonColor = .primaryColor()
    }
    
    private lazy var categoryButton = UIButton().then {
        $0.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        $0.tintColor = .label
    }
    
    override init() {
        super.init(node: ProductListViewContainer())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(floating)
        self.loadNode()
        reactor = ProductListViewReactor()
        
        Observable.just(type != .none)
            .bind(to: floating.rx.isHidden, categoryButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
        
        var data: Observable<ProductListViewReactor.Action> = .empty()
        
        switch (self.type) {
            case .none:
                data = Observable.just(Reactor.Action.fetchProduct)
            case .sales:
                data = Observable.just(Reactor.Action.fetchMyProduct)
                self.navigationItem.title = "판매내역"
            case .like:
                data = Observable.just(Reactor.Action.fetchLikeProduct)
                self.navigationItem.title = "관심목록"
            default:
                break
        }
    
        data.bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    private func presentProductAddView() {
        self.navigationController?.pushViewController(ProductAddViewController().then {
            $0.hidesBottomBarWhenPushed = true
        }, animated: true)
    }
    
    private func presentLocalPostAddView() {
        self.navigationController?.pushViewController(LocalPostAddViewController().then {
            $0.hidesBottomBarWhenPushed = true
        }, animated: true)
    }
    
    private func presentCategoryView() {
        self.navigationController?.pushViewController(CategorySelectViewController().then {
            $0.hidesBottomBarWhenPushed = true
        }, animated: true)
    }
    
    public func moveToStart(){
        AuthController.getInstance().logout()
        DispatchQueue.main.async {
            let vc = ASNavigationController(rootViewController: StartViewController()).then {
                $0.modalPresentationStyle = .fullScreen
                $0.modalTransitionStyle = .crossDissolve
            }
            self.navigationController?.present(vc, animated: true)
        }
    }
}

extension ProductListViewController: ViewControllerType {
    
    func initNode() {
        self.node.do {
            $0.automaticallyManagesSubnodes = true
            $0.backgroundColor = .systemBackground
            
            $0.tableNode.delegate = self
            $0.tableNode.dataSource = self
        }
    }
    
    func loadNode() {
        self.node.do {
            $0.tableNode.view.showsVerticalScrollIndicator = false
            $0.tableNode.view.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: categoryButton)
        ]
    }
    
    func bind(reactor: ProductListViewReactor) {
        // Action
        productButton.handler = { _ in
            self.presentProductAddView()
        }
        
        localPostButton.handler = { _ in
            self.presentLocalPostAddView()
        }
        
        categoryButton.rx.tap
            .bind(onNext: presentCategoryView)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.products }
            .withUnretained(self)
            .filter { !$0.0.products.contains($0.1) }
            .bind { owner, products in
                owner.products = products
                owner.node.tableNode.reloadData()
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.currentCity }
            .withUnretained(self)
            .filter { $0.1 != nil && $0.0.type == .none }
            .bind { $0.0.navigationItem.title = $0.1 }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: view.rx.loading)
            .disposed(by: disposeBag)
        
        let error = reactor.state
            .filter { $0.errorMessage != nil }
            .map { $0.errorMessage! }
            .share()
            
        error
            .bind(to: view.rx.error)
            .disposed(by: disposeBag)
        
        error
            .withUnretained(self)
            .bind { $0.0.moveToStart() }
            .disposed(by: disposeBag)
    }
}

extension ProductListViewController: ASTableDelegate {
    
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(
            min: CGSize(width: width, height: 0),
            max: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        )
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let item = products[indexPath.row]
        
        let vc = ProductDetailViewController().then {
            $0.idx = item.idx
            $0.hidesBottomBarWhenPushed = true
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProductListViewController: ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] in
            guard let self = self else { return ASCellNode() }
            
            let item = self.products[indexPath.row]
            
            let cell = ProductCell().then {
                $0.alpha = item.isSold ? 0.5 : 1
                $0.selectionStyle = .none
            }
            
            Observable.just(item)
                .bind(to: cell.rx.product)
                .disposed(by: self.disposeBag)
            
            return cell
        }
    }
}
