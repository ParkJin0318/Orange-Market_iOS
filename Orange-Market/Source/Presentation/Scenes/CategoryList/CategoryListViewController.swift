//
//  CategoryListViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/28.
//

import AsyncDisplayKit
import RxSwift

class CategoryListViewController: ASDKViewController<CategoryListViewContainer> {
    
    lazy var disposeBag = DisposeBag()
    lazy var viewModel = CategoryListViewModel()
    
    var selectCategory: Category!
    
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
        self.bind()
        viewModel.getAllCategory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
    
    private func popViewController() {
        self.navigationController?.popViewController(animated: true)
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
        
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "카테고리 선택"
        self.navigationController?.navigationBar.tintColor = .label
    }
    
    func bind() {
        viewModel.output.onReloadEvent
            .filter { $0 }
            .withUnretained(self)
            .bind { owner, value in
                owner.node.tableNode.reloadData()
            }.disposed(by: disposeBag)
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
        let item = viewModel.output.categoryList[indexPath.row]
        selectCategory = item
        popViewController()
    }
}

extension CategoryListViewController: ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.categoryList.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] in
            let item = self?.viewModel.output.categoryList[indexPath.row]
            
            return CategoryCell().then {
                $0.setupNode(category: item!)
            }
        }
    }
}
