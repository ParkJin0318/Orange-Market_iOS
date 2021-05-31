//
//  TopicListViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/26.
//

import AsyncDisplayKit
import RxDataSources_Texture
import ReactorKit

class TopicListViewController: ASDKViewController<TopicListViewContainer> & View {
    
    var disposeBag = DisposeBag()
    
    var selectTopic: LocalTopic? = nil
    
    var topicDataSource: RxASTableSectionedAnimatedDataSource<LocalTopicListSection>!
    
    override init() {
        super.init(node: TopicListViewContainer())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNode()
        self.setupDataSource()
        reactor = TopicListViewReactor()
        
        Observable.just(.fetchTopic)
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    private func setupDataSource() {
        topicDataSource = RxASTableSectionedAnimatedDataSource<LocalTopicListSection>(
            configureCellBlock: { _, _, _, item in
                switch item {
                    case .localTopic(let topic):
                        return { CategoryCell(topic: topic) }
                }
            }
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
}

extension TopicListViewController: ViewControllerType {
    
    func initNode() {
        self.node.do {
            $0.backgroundColor = .systemBackground
        }
    }
    
    func loadNode() {
        self.node.tableNode.view.separatorStyle = .none
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "주제 선택"
        self.navigationController?.navigationBar.tintColor = .label
    }
    
    func bind(reactor: TopicListViewReactor) {
        // Action
        node.tableNode.rx.itemSelected
            .map { .tapItem($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.topics }
            .map { $0.map { LocalTopicListSectionItem.localTopic($0) } }
            .map { [LocalTopicListSection.localTopic(localTopics: $0)] }
            .bind(to: node.tableNode.rx.items(dataSource: topicDataSource))
            .disposed(by: disposeBag)
        
        let tapItem = reactor.state
            .map { $0.tapItem }
            .distinctUntilChanged()
            .share()
        
        tapItem.filter { $0 != nil }
            .withUnretained(self)
            .bind { owner, value in
                owner.selectTopic = value
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
