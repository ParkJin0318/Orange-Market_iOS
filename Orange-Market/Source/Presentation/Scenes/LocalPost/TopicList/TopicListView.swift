//
//  TopicListView.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/26.
//

import AsyncDisplayKit
import ReactorKit

class TopicListViewController: ASDKViewController<TopicListViewContainer> & View {
    
    var disposeBag = DisposeBag()
    
    lazy var topics: [LocalTopic] = []
    var selectTopic: LocalTopic? = nil
    
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
        reactor = TopicListViewReactor()
        
        Observable.just(.fetchTopic)
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
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
            
            $0.tableNode.delegate = self
            $0.tableNode.dataSource = self
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
        // State
        reactor.state.map { $0.topics }
            .withUnretained(self)
            .filter { !$0.0.topics.contains($0.1) }
            .bind { owner, value in
                owner.topics = value
                owner.node.tableNode.reloadData()
            }.disposed(by: disposeBag)
    }
}

extension TopicListViewController: ASTableDelegate {
    
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(
            min: CGSize(width: width, height: 0),
            max: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        )
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let item = topics[indexPath.row]
        selectTopic = item
        
        Observable.just(true)
            .bind(to: self.rx.pop)
            .disposed(by: disposeBag)
    }
}

extension TopicListViewController: ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] in
            guard let self = self else { return ASCellNode() }
            
            let item = self.topics[indexPath.row]
            
            let cell = CategoryCell()
            
            Observable.just(item)
                .map { $0.name.toAttributed(color: .label, ofSize: 14) }
                .bind(to: cell.nameNode.rx.attributedText)
                .disposed(by: self.disposeBag)
            
            return cell
        }
    }
}

