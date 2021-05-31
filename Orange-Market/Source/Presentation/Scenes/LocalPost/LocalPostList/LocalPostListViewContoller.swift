//
//  LocalPostListViewContoller.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import AsyncDisplayKit
import RxDataSources_Texture
import ReactorKit
import MBProgressHUD
import Floaty

class LocalPostListViewContoller: ASDKViewController<LocalPostListViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    var topic: LocalTopic? = nil
    
    lazy var floating = Floaty().then {
        $0.buttonColor = .primaryColor()
        $0.plusColor = .white
        
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
    
    let postDataSource = RxASTableSectionedAnimatedDataSource<LocalPostListSection>(
        configureCellBlock: { _, _, _, item in
            switch item {
                case .localPost(let post):
                    return { LocalPostCell(post: post) }
            }
    })
    
    let topicDataSource = RxASCollectionSectionedReloadDataSource<LocalTopicListSection>(
        configureCellBlock: { _, _, _, item in
            switch item {
                case .localTopic(let topic):
                    return { LocalTopicCell(topic: topic) }
            }
        }
    )
    
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
        
        node.tableNode.rx.itemSelected
            .map { .tapPostItem($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        node.collectionNode.rx.itemSelected
            .map { .tapTopicItem($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.localPosts }
            .map { $0.map { LocalPostListSectionItem.localPost($0) } }
            .map { [LocalPostListSection.localPost(localPosts: $0)] }
            .bind(to: node.tableNode.rx.items(dataSource: postDataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.tapPostItem }
            .distinctUntilChanged()
            .filter { $0 != nil }
            .withUnretained(self)
            .bind { owner, value in
                let vc = LocalPostDetailViewController().then {
                    $0.idx = value!
                    $0.hidesBottomBarWhenPushed = true
                }
                owner.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.currentCity }
            .withUnretained(self)
            .filter { $0.0.topic == nil }
            .map { $0.1 }
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
            
        reactor.state.map { $0.localTopics }
            .map { $0.map { LocalTopicListSectionItem.localTopic($0) } }
            .map { [LocalTopicListSection.localTopic(localTopics: $0)] }
            .bind(to: node.collectionNode.rx.items(dataSource: topicDataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.tapTopicItem }
            .distinctUntilChanged()
            .filter { $0 != nil }
            .withUnretained(self)
            .bind { owner, value in
                if (value!.idx == 0) {
                    self.navigationController?
                        .pushViewController(TopicSelectViewController(), animated: true)
                } else {
                    let vc = LocalPostListViewContoller().then {
                        $0.topic = value!
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
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
