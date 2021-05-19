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

class ProductListViewController: ASDKViewController<ProductListViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    
    lazy var products: [Product] = []
    var type: ProductType = .none
    
    private lazy var writeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        $0.tintColor = .label
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
        self.loadNode()
        reactor = ProductListViewReactor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
        
        if let reactor = self.reactor {
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
        
            Observable.just(type != .none)
                .bind(to: writeButton.rx.isHidden, categoryButton.rx.isHidden)
                .disposed(by: disposeBag)
            
            data.bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
    }
    
    private func presentProductAddView() {
        self.navigationController?.pushViewController(ProductAddViewController().then {
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
            UIBarButtonItem(customView: writeButton),
            UIBarButtonItem(customView: categoryButton)
        ]
    }
    
    func bind(reactor: ProductListViewReactor) {
        // Action
        writeButton.rx.tap
            .bind(onNext: presentProductAddView)
            .disposed(by: disposeBag)
        
        categoryButton.rx.tap
            .bind(onNext: presentCategoryView)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.products }
            .withUnretained(self)
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
                owner.moveToStart()
            }.disposed(by: disposeBag)
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
            
            let cell = ProductCell().then {
                $0.selectionStyle = .none
            }
            
            if let item = self?.products[indexPath.row] {
                cell.do {
                    $0.setupNode(product: item)
                    $0.alpha = item.isSold ? 0.5 : 1
                }
            }
            return cell
        }
    }
}
