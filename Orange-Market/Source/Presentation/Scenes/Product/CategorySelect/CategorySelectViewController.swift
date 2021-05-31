//
//  CategorySelectViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/04/26.
//

import AsyncDisplayKit
import RxDataSources_Texture
import ReactorKit
import RxSwift
import BEMCheckBox
import MBProgressHUD

class CategorySelectViewController: ASDKViewController<CategorySelectViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    
    var rxDataSource: RxASCollectionSectionedAnimatedDataSource<CategoryListSection>!
    
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
        self.setupDataSource()
        reactor = CategorySelectViewReactor()
        
        self.setupData()
    }
    
    private func setupDataSource() {
        rxDataSource = RxASCollectionSectionedAnimatedDataSource<CategoryListSection>(
            configureCellBlock: { _, _, _, item in
                switch item {
                    case .category(let category):
                        return {
                            let cell = CategoryCheckBoxCell(category: category)
                            cell.delegate = self
                            return cell
                        }
                }
        })
    }
    
    private func setupData() {
        node.collectionNode.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable.just(.fetchCategory)
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
}

extension CategorySelectViewController: ViewControllerType {
    
    func initNode() {
        self.node.do {
            $0.backgroundColor = .systemBackground
            $0.titleNode.attributedText = "홈 화면에서 보고 싶은 카테고리는 \n체크하세요.".toCenterAttributed(color: .label, ofSize: 15)
            $0.descriptionNode.attributedText = "최소 1개 이상 선택되어 있어야 합니다.".toAttributed(color: .lightGray, ofSize: 14)
        }
    }
    
    func loadNode() { }
    
    func setupNavigationBar() {
        self.navigationItem.title = "카테고리 설정"
        self.navigationController?.navigationBar.tintColor = .label
    }
    
    func bind(reactor: CategorySelectViewReactor) {
        // State
        reactor.state.map { $0.categories }
            .distinctUntilChanged()
            .map { $0.map { CategoryListSectionItem.category($0) } }
            .map { [CategoryListSection.category(categories: $0)] }
            .bind(to: node.collectionNode.rx.items(dataSource: rxDataSource))
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

extension CategorySelectViewController: CheckBoxCellDelegate {
    
    func setCheckedItem(idx: Int) {
        Observable.just(.updateCategory(idx))
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
}

extension CategorySelectViewController: ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(
            min: CGSize(width: width / 2.5, height: 0),
            max: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        )
    }
}
