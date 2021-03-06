//
//  CategoryListViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/28.
//

import AsyncDisplayKit
import RxDataSources_Texture
import ReactorKit
import RxSwift
import MBProgressHUD

class CategoryListViewController: ASDKViewController<CategoryListViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    
    var selectCategory: ProductCategory!
    
    var rxDataSource: RxASTableSectionedAnimatedDataSource<CategoryListSection>!
    
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
        self.setupDataSource()
        reactor = CategoryListViewReactor()
        
        Observable.just(.fetchCategory)
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    private func setupDataSource() {
        rxDataSource = RxASTableSectionedAnimatedDataSource<CategoryListSection>(
            configureCellBlock: { _, _, _, item in
                switch item {
                    case .category(let category):
                        return { CategoryCell(category: category) }
                }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
}

extension CategoryListViewController: ViewControllerType {
    
    func initNode() {
        self.node.do {
            $0.backgroundColor = .systemBackground
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
        // Action
        node.tableNode.rx.itemSelected
            .map { .tapItem($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.categories }
            .map { $0.map { CategoryListSectionItem.category($0) } }
            .map { [CategoryListSection.category(categories: $0)] }
            .bind(to: node.tableNode.rx.items(dataSource: rxDataSource))
            .disposed(by: disposeBag)
        
        let tapItem = reactor.state
            .map { $0.tapItem }
            .distinctUntilChanged()
            .share()
        
        tapItem.filter { $0 != nil }
            .withUnretained(self)
            .bind { owner, value in
                owner.selectCategory = value
            }.disposed(by: disposeBag)
        
        tapItem.map { $0 != nil }
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
