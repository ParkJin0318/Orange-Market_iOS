//
//  LocalPostListViewContoller.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import AsyncDisplayKit
import ReactorKit
import MBProgressHUD
import Floaty

class LocalPostListViewContoller: ASDKViewController<LocalPostListViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    
    lazy var localPosts: [LocalPost] = []
    lazy var localTopics: [LocalTopic] = []
    
    var topic: LocalTopic? = nil
    
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
    
    override init() {
        super.init(node: LocalPostListViewContainer())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(floating)
        self.loadNode()
        reactor = LocalPostListViewReactor()
        
        Observable.just(topic != nil)
            .bind(to: floating.rx.isHidden)
            .disposed(by: disposeBag)
        
        Observable.just(.fetchLocalTopic)
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
        
        let topic = Observable.just(self.topic)
            .share()
        
        topic.map { $0 == nil ? .fetchLocalPost : .filterLocalPost($0!.idx)}
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
        
        topic.map { $0 != nil }
            .bind(to: node.rx.isTopicHidden)
            .disposed(by: disposeBag)
        
        topic.filter { $0 != nil }
            .map { $0!.name }
            .bind(to: navigationItem.rx.title)
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
}

extension LocalPostListViewContoller: ViewControllerType {
    
    func initNode() {
        self.node.do {
            $0.automaticallyManagesSubnodes = true
            $0.backgroundColor = .systemBackground
            
            $0.tableNode.delegate = self
            $0.tableNode.dataSource = self
            
            $0.collectionNode.delegate = self
            $0.collectionNode.dataSource = self
        }
    }
    
    func loadNode() {
        self.node.do {
            $0.collectionNode.view.showsHorizontalScrollIndicator = false
            $0.tableNode.view.showsVerticalScrollIndicator = false
            $0.tableNode.view.separatorStyle = .none
        }
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
    }
    
    func bind(reactor: LocalPostListViewReactor) {
        // Action
        productButton.handler = { _ in
            self.presentProductAddView()
        }
        
        localPostButton.handler = { _ in
            self.presentLocalPostAddView()
        }
        
        // State
        reactor.state.map { $0.localPosts }
            .withUnretained(self)
            .filter { !$0.0.localPosts.contains($0.1) }
            .bind { owner, value in
                owner.localPosts = value
                owner.node.tableNode.reloadData()
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.currentCity }
            .withUnretained(self)
            .filter { $0.0.topic == nil }
            .map { $0.1 }
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
            
        reactor.state.map { $0.localTopics }
            .withUnretained(self)
            .filter { !$0.0.localTopics.contains($0.1) }
            .bind { owner, value in
                owner.localTopics = value
                owner.node.collectionNode.reloadData()
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

extension LocalPostListViewContoller: ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(
            min: CGSize(width: 0, height: 0),
            max: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        )
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let item = localTopics[indexPath.row]
        
        if (item.idx == 0) {
            
        } else {
            let vc = LocalPostListViewContoller().then {
                $0.topic = item
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension LocalPostListViewContoller: ASCollectionDataSource {
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return localTopics.count
    }

    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] in
            guard let self = self else { return ASCellNode() }
            
            let item = self.localTopics[indexPath.row]
            
            let cell = LocalTopicCell().then {
                $0.cornerRadius = 4
            }
            
            if (item.idx == 0) {
                Observable.just(UIImage(systemName: "slider.horizontal.3"))
                    .bind(to: cell.topicNode.imageNode.rx.image)
                    .disposed(by: self.disposeBag)
            } else {
                Observable.just(item)
                    .map { $0.name.toAttributed(color: .label, ofSize: 12) }
                    .bind(to: cell.topicNode.titleNode.rx.attributedText)
                    .disposed(by: self.disposeBag)
            }
            
            return cell
        }
    }
}

