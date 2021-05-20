//
//  LocalPostListViewContoller.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import AsyncDisplayKit
import ReactorKit
import MBProgressHUD

class LocalPostListViewContoller: ASDKViewController<LocalPostListViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    lazy var localPosts: [LocalPost] = []
    
    override init() {
        super.init(node: LocalPostListViewContainer())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNode()
        reactor = LocalPostListViewReactor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
        
        if let reactor = self.reactor {
            Observable.just(.fetchLocalPost)
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
    }
}

extension LocalPostListViewContoller: ViewControllerType {
    
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
            $0.tableNode.view.separatorStyle = .none
            $0.tableNode.view.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
    }
    
    func bind(reactor: LocalPostListViewReactor) {
        // State
        reactor.state.map { $0.localPosts }
            .withUnretained(self)
            .bind { owner, value in
                owner.localPosts = value
                owner.navigationItem.title = value.first?.city
                owner.node.tableNode.reloadData()
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

extension LocalPostListViewContoller: ASTableDelegate {
    
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(
            min: CGSize(width: width, height: 0),
            max: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        )
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let item = localPosts[indexPath.row]
        
        let vc = LocalPostDetailViewController().then {
            $0.idx = item.idx
            $0.hidesBottomBarWhenPushed = true
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension LocalPostListViewContoller: ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return localPosts.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] in
            guard let self = self else { return ASCellNode() }
            
            let item = self.localPosts[indexPath.row]
            
            let cell = LocalPostCell().then {
                $0.selectionStyle = .none
            }
            
            Observable.just(item)
                .bind(to: cell.rx.post)
                .disposed(by: self.disposeBag)
            
            return cell
        }
    }
}
