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
    
    private lazy var moreButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        $0.tintColor = .label
    }
    
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
    
    func commentAlret(idx: Int) {
        let actions: [UIAlertController.AlertAction] = [
            .action(title: "삭제", style: .destructive),
            .action(title: "취소", style: .cancel)
        ]
        
        UIAlertController
            .present(in: self, title: "댓글", message: "댓글 상태 변경", style: .actionSheet, actions: actions)
            .withUnretained(self)
            .subscribe { owner, value in
                switch (value) {
                    case 0:
                        Observable.just(.deleteLocalComment(idx))
                            .bind(to: owner.reactor!.action)
                            .disposed(by: owner.disposeBag)
                    default:
                        break
                }
            }.disposed(by: disposeBag)
    }
    
    func postAlret() {
        let actions: [UIAlertController.AlertAction] = [
            .action(title: "삭제", style: .destructive),
            .action(title: "취소", style: .cancel)
        ]
        
        UIAlertController
            .present(in: self, title: "게시물", message: "게시물 상태 변경", style: .actionSheet, actions: actions)
            .withUnretained(self)
            .subscribe { owner, value in
                switch (value) {
                    case 0:
                        Observable.just(.deleteLocalPost(owner.idx))
                            .bind(to: owner.reactor!.action)
                            .disposed(by: owner.disposeBag)
                    default:
                        break
                }
            }.disposed(by: disposeBag)
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
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: moreButton)
        ]
    }
    
    func bind(reactor: LocalPostDetailViewReactor) {
        //Action
        moreButton.rx.tap
            .bind(onNext: postAlret)
            .disposed(by: disposeBag)
        
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
        
        Observable.combineLatest(
            reactor.state.map { $0.localPost },
            reactor.state.map { $0.localComments }
        ).withUnretained(self)
        .filter { !$0.0.localComments.contains($0.1.1) }
        .bind { owner, value in
            owner.localPost = value.0
            owner.localComments = value.1
            owner.node.tableNode.reloadData()
        }.disposed(by: disposeBag)
        
        reactor.state.map { $0.isSuccessDeleteLocalPost }
            .distinctUntilChanged()
            .filter { $0 }
            .bind(to: self.rx.pop)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isSuccessDeleteLocalComment }
            .distinctUntilChanged()
            .filter { $0 }
            .withUnretained(self)
            .map { .fetchLocalComments($0.0.idx) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isSuccessSendComment }
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
                let cell = LocalCommentCell().then {
                    $0.selectionStyle = .none
                }
                
                let item = self.localComments[indexPath.row]
                    
                let comment = Observable.just(item)
                    .share()
                
                comment.bind(to: cell.rx.comment)
                    .disposed(by: self.disposeBag)
                
                comment.map { !$0.isMyComment }
                    .bind(to: cell.moreNode.rx.isHidden)
                    .disposed(by: self.disposeBag)
                    
                cell.moreNode.rx.tap
                    .bind { self.commentAlret(idx: item.idx) }
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
