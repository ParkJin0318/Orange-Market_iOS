//
//  TopicSelectViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/26.
//

import AsyncDisplayKit
import RxDataSources_Texture
import ReactorKit

class TopicSelectViewController: ASDKViewController<TopicSelectViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    
    var topicDataSource: RxASCollectionSectionedReloadDataSource<LocalTopicListSection>!
    
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
        self.setupDataSource()
        reactor = TopicSelectViewReactor()
        
        self.setupData()
    }
    
    private func setupData() {
        node.collectionNode
            .rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable.just(.fetchTopic)
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    private func setupDataSource() {
        topicDataSource = RxASCollectionSectionedReloadDataSource<LocalTopicListSection>(
            configureCellBlock: { _, _, _, item in
                switch item {
                    case .localTopic(let topic):
                        return { LocalTopicCheckBoxCell(topic: topic).then {
                            $0.delegate = self
                            $0.cornerRadius = 5
                            $0.borderWidth = 1
                            $0.borderColor = UIColor.lightGray().cgColor
                        } }
                }
            }
        )
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
            .distinctUntilChanged()
            .map { $0.map { LocalTopicListSectionItem.localTopic($0) } }
            .map { [LocalTopicListSection.localTopic(localTopics: $0)] }
            .bind(to: node.collectionNode.rx.items(dataSource: topicDataSource))
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
extension TopicSelectViewController: CheckBoxCellDelegate {
    
    func setCheckedItem(idx: Int) {
        Observable.just(.updateTopic(idx))
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
}

extension TopicSelectViewController: ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(
            min: CGSize(width: width / 4.5, height: 0),
            max: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        )
    }
}
