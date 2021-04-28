//
//  CategoryViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/26.
//

import AsyncDisplayKit
import RxSwift
import BEMCheckBox

class CategoryViewController: ASDKViewController<CategoryViewContainer> {
    
    lazy var disposeBag = DisposeBag()
    lazy var viewModel = CategoryViewModel()
    
    override init() {
        super.init(node: CategoryViewContainer())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind()
        viewModel.getAllCategory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
}

extension CategoryViewController: ViewControllerType {
    
    func initNode() {
        self.node.do {
            $0.automaticallyManagesSubnodes = true
            $0.backgroundColor = .systemBackground
            
            $0.collectionNode.delegate = self
            $0.collectionNode.dataSource = self
            
            $0.titleNode.attributedText = "홈 화면에서 보고 싶은 카테고리는 \n체크하세요.".toCenterAttributed(color: .label, ofSize: 15)
            $0.descriptionNode.attributedText = "최소 1개 이상 선택되어 있어야 합니다.".toAttributed(color: .lightGray, ofSize: 14)
        }
    }
    
    func loadNode() {
        
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "카테고리 설정"
        self.navigationController?.navigationBar.tintColor = .label
    }
    
    func bind() {
        viewModel.output.onReloadEvent
            .filter { $0 }
            .withUnretained(self)
            .bind { owner, value in
                owner.node.collectionNode.reloadData()
            }.disposed(by: disposeBag)
    }
}

extension CategoryViewController: ASCollectionDelegate, CategoryCellDelegate {
    
    func setCheckedCategory(idx: Int) {
        viewModel.updateCategory(idx: idx)
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(
            min: CGSize(width: width / 2.5, height: 0),
            max: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        )
    }
}

extension CategoryViewController: ASCollectionDataSource {
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.categoryList.count
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] in
            let item = self?.viewModel.output.categoryList[indexPath.row]
            
            return CategoryCell().then {
                $0.delegate = self
                $0.setupNode(category: item!)
            }
        }
    }
}
