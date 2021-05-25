//
//  LocalPostDetailViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/20.
//

import AsyncDisplayKit
import ReactorKit
import MBProgressHUD

class LocalPostDetailViewController: ASDKViewController<LocalPostDetailViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    
    var localPost: LocalPost? = nil
    lazy var localComments: [LocalComment] = []
    
    var idx: Int = -1
    
    override init() {
        super.init(node: LocalPostDetailViewContainer())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNode()
        reactor = LocalPostDetailViewReactor()
        
        Observable.concat([
            .just(.fetchUserInfo),
            .just(.fetchLocalPost(idx)),
            .just(.fetchLocalComments(idx))
        ]).bind(to: reactor!.action)
        .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
        self.addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotifications()
    }
}

extension LocalPostDetailViewController: ViewControllerType {
    
    func initNode() {
        self.node.do {
            $0.automaticallyManagesSubnodes = true
            $0.backgroundColor = .systemBackground
            
            $0.tableNode.delegate = self
            $0.tableNode.dataSource = self
            
            $0.localPostCommentNode.commentInputNode.commentField.placeholder = "따뜻한 댓글을 입력해주세요 :)"
        }
    }
    
    func loadNode() {
        self.node.localPostCommentNode.commentInputNode.commentField.delegate = self
        
        self.node.do {
            $0.tableNode.view.showsVerticalScrollIndicator = false
            $0.tableNode.view.separatorStyle = .none
        }
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
    }
    
    func bind(reactor: LocalPostDetailViewReactor) {
        //Action
        node.localPostCommentNode.commentInputNode.do {
            $0.sendNode.rx.tap
                .withUnretained(self)
                .map { .sendComment($0.0.idx) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
            
            $0.commentField.rx.text.orEmpty
                .map { .comment($0) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
        
        // State
        let comment = reactor.state
            .map { $0.comment }
            .share()
        
        comment
            .bind(to: node.localPostCommentNode.commentInputNode.commentField.rx.text.orEmpty)
            .disposed(by: disposeBag)
        
        comment
            .map { $0.count <= 0 }
            .bind(to: node.localPostCommentNode.commentInputNode.sendNode.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.localPost }
            .withUnretained(self)
            .bind { owner, value in
                owner.localPost = value
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.localComments }
            .withUnretained(self)
            .filter { !$0.0.localComments.contains($0.1) }
            .bind { owner, value in
                owner.localComments = value
                owner.node.tableNode.reloadData()
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.isSuccessComment }
            .distinctUntilChanged()
            .filter { $0 }
            .withUnretained(self)
            .map { .fetchLocalComments($0.0.idx) }
            .bind(to:reactor.action)
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

extension LocalPostDetailViewController: ASTableDelegate {
    
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(
            min: CGSize(width: width, height: 0),
            max: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        )
    }
}

extension LocalPostDetailViewController: ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else {
            return localComments.count
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] in
            guard let self = self else { return ASCellNode() }
            
            if (indexPath.section == 0) {
                let cell = LocalContentCell().then {
                    $0.selectionStyle = .none
                }
                
                Observable.just(self.localPost)
                    .filter { $0 != nil }
                    .map { $0! }
                    .bind(to: cell.rx.content)
                    .disposed(by: self.disposeBag)
                
                return cell
                
            } else {
                let item = self.localComments[indexPath.row]
                
                let cell = LocalCommentCell().then {
                    $0.selectionStyle = .none
                }
                
                Observable.just(item)
                    .bind(to: cell.rx.comment)
                    .disposed(by: self.disposeBag)
                
                return cell
            }
        }
    }
}

extension LocalPostDetailViewController: UITextFieldDelegate {
    
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func removeKeyboardNotifications(){
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
        
    @objc func keyboardWillShow(_ noti: NSNotification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.node.keyboardVisibleHeight = keyboardRectangle.height - (tabBarHeight - 60)
            self.node.setNeedsLayout()
        }
    }

    @objc func keyboardWillHide(_ noti: NSNotification) {
        self.node.keyboardVisibleHeight = 0.0
        self.node.setNeedsLayout()
    }
}
