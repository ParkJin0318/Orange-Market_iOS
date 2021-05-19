//
//  CategorySelectViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/26.
//

import AsyncDisplayKit
import ReactorKit
import RxSwift
import BEMCheckBox
import MBProgressHUD

class CategorySelectViewController: ASDKViewController<CategorySelectViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    lazy var categories: [ProductCategory] = []
    
    override init() {
        super.init(node: CategorySelectViewContainer())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNode()
        reactor = CategorySelectViewReactor()
        
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

extension CategorySelectViewController: ViewControllerType {
    
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
    
    func bind(reactor: CategorySelectViewReactor) {
        reactor.state.map { $0.categories }
            .withUnretained(self)
            .filter { !$0.1.map { $0.idx}.elementsEqual($0.0.categories.map { $0.idx }) }
            .bind { owner, value in
                owner.categories = value
                owner.node.collectionNode.reloadData()
            }.disposed(by: disposeBag)
        
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

extension CategorySelectViewController: ASCollectionDelegate, CategoryCheckBoxCellDelegate {
    
    func setCheckedCategory(idx: Int) {
        if let reactor = self.reactor {
            Observable.just(.updateCategory(idx))
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(
            min: CGSize(width: width / 2.5, height: 0),
            max: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        )
    }
}

extension CategorySelectViewController: ASCollectionDataSource {
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] in
            let item = self?.categories[indexPath.row]
            
            return CategoryCheckBoxCell().then {
                $0.delegate = self
                $0.setupNode(category: item!)
            }
        }
    }
}
