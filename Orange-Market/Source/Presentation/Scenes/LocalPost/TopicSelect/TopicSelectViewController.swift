//
//  TopicSelectViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/26.
//

import AsyncDisplayKit
import ReactorKit

class TopicSelectViewController: ASDKViewController<TopicSelectViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    lazy var topics: [LocalTopic] = []
    
    override init() {
        super.init(node: TopicSelectViewContainer())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNode()
        reactor = TopicSelectViewReactor()
        
        Observable.just(.fetchTopic)
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
}

extension TopicSelectViewController: ViewControllerType {
    
    func initNode() {
        self.node.do {
            $0.backgroundColor = .systemBackground
            
            $0.collectionNode.delegate = self
            $0.collectionNode.dataSource = self
            
            $0.titleNode.attributedText = "지역생활에서 보고 싶은 \n관심주제들만 선택해보세요.".toBoldAttributed(color: .label, ofSize: 18)
        }
    }
    
    func loadNode() {
        self.node.do {
            $0.collectionNode.view.showsVerticalScrollIndicator = false
        }
    }
    
    func setupNavigationBar() {
        navigationItem.title = "관심주제 설정"
    }
    
    func bind(reactor: TopicSelectViewReactor) {
        // State
        reactor.state.map { $0.topics }
            .withUnretained(self)
            .filter { !$0.0.topics.contains($0.1) }
            .bind { owner, value in
                owner.topics = value
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

extension TopicSelectViewController: ASCollectionDelegate, CheckBoxCellDelegate {
    
    func setCheckedItem(idx: Int) {
        Observable.just(.updateTopic(idx))
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(
            min: CGSize(width: width / 4.5, height: 0),
            max: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        )
    }
}

extension TopicSelectViewController: ASCollectionDataSource {
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] in
            guard let self = self else { return ASCellNode() }
            
            let item = self.topics[indexPath.row]
            
            let cell = LocalTopicCheckBoxCell().then {
                $0.topic = item
                $0.delegate = self
                $0.cornerRadius = 5
                $0.borderWidth = 1
                $0.borderColor = UIColor.lightGray().cgColor
            }
            
            Observable.just(item)
                .map { $0.name.toCenterAttributed(color: .label, ofSize: 12) }
                .bind(to: cell.nameNode.rx.attributedText)
                .disposed(by: self.disposeBag)
            
            Observable.just(UIColor.lightGray())
                .bind(to: cell.imageNode.rx.backgroundColor)
                .disposed(by: self.disposeBag)
            
            return cell
        }
    }
}
