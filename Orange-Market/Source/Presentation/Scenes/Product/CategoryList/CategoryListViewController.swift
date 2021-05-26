//
//  CategoryListViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/28.
//

import AsyncDisplayKit
import ReactorKit
import RxSwift
import MBProgressHUD

class CategoryListViewController: ASDKViewController<CategoryListViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    lazy var categories: [ProductCategory] = []
    
    var selectCategory: ProductCategory!
    
    override init() {
        super.init(node: CategoryListViewContainer())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNode()
        reactor = CategoryListViewReactor()
        
        if let reactor = self.reactor {
            Observable.just(.fetchCategory)
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
}

extension CategoryListViewController: ViewControllerType {
    
    func initNode() {
        self.node.do {
            $0.automaticallyManagesSubnodes = true
            $0.backgroundColor = .systemBackground
            
            $0.tableNode.delegate = self
            $0.tableNode.dataSource = self
        }
    }
    
    func loadNode() {
        self.node.tableNode.view.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "카테고리 선택"
        self.navigationController?.navigationBar.tintColor = .label
    }
    
    func bind(reactor: CategoryListViewReactor) {
        reactor.state.map { $0.categories }
            .withUnretained(self)
            .filter { !$0.0.categories.contains($0.1) }
            .bind { owner, value in
                owner.categories = value
                owner.node.tableNode.reloadData()
            }.disposed(by: disposeBag)
        
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

extension CategoryListViewController: ASTableDelegate {
    
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(
            min: CGSize(width: width, height: 0),
            max: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        )
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let item = categories[indexPath.row]
        selectCategory = item
        
        Observable.just(true)
            .bind(to: self.rx.pop)
            .disposed(by: disposeBag)
    }
}

extension CategoryListViewController: ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] in
            guard let self = self else { return ASCellNode() }
            
            let item = self.categories[indexPath.row]
            
            let cell = CategoryCell()
            
            Observable.just(item)
                .map { $0.name.toAttributed(color: .label, ofSize: 14) }
                .bind(to: cell.nameNode.rx.attributedText)
                .disposed(by: self.disposeBag)
            
            return cell
        }
    }
}
