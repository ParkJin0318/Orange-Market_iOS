//
//  LocalPostAddViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/26.
//

import AsyncDisplayKit
import ReactorKit

class LocalPostAddViewController: ASDKViewController<LocalPostAddViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    
    lazy var topicListViewController = TopicListViewController()
    
    var localPost: LocalPost? = nil
    
    lazy var closeButton = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.label, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
    lazy var completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.label, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
    override init() {
        super.init(node: LocalPostAddViewContainer())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNode()
        reactor = LocalPostAddViewReactor()
        
        Observable.just(.fetchLocalPost(localPost))
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
        self.setupTopic()
    }
    
    private func setupTopic() {
        let topic = Observable.just(topicListViewController.selectTopic)
            .filter { $0 != nil }
            .map { $0! }
            .share()
        
        topic.map { $0.idx }
            .map { .topicIdx($0) }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
        
        topic.map { $0.name }
            .map { .topic($0) }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    private func presentTopicListView() {
        self.navigationController?.pushViewController(topicListViewController, animated: true)
    }
}

extension LocalPostAddViewController: ViewControllerType {
    
    func initNode() {
        self.node.do {
            $0.backgroundColor = .systemBackground
            
            $0.contentField.placeholder = "우리 지역 관련된 질문이나 이야기를 해보세요."
        }
    }
    
    func loadNode() { }
    
    func setupNavigationBar() {
        self.navigationItem.do {
            if (localPost == nil) {
                $0.title = "지역생활 글쓰기"
            } else {
                $0.title = "지역생활 글 수정하기"
            }
           
            $0.leftBarButtonItems = [
                UIBarButtonItem(customView: closeButton)
            ]
            $0.rightBarButtonItems = [
                UIBarButtonItem(customView: completeButton)
            ]
        }
    }
    
    func bind(reactor: LocalPostAddViewReactor) {
        // Action
        closeButton.rx.tap
            .map { true }
            .bind(to: self.rx.pop)
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .map { self.localPost == nil ? .savePost : .updatePost }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        node.contentField.rx.text.orEmpty
            .map { .content($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        node.topicSelectNode.rx.tap
            .bind(onNext: presentTopicListView)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.topic.toAttributed(color: .label, ofSize: 16) }
            .bind(to: node.topicSelectNode.nameNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.content }
            .bind(to: node.contentField.rx.text.orEmpty)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isSuccess }
            .distinctUntilChanged()
            .filter { $0 }
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
