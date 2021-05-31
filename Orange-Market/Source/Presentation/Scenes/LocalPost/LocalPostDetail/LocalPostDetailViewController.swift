//
//  LocalPostDetailViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/05/20.
//

import AsyncDisplayKit
import RxDataSources_Texture
import ReactorKit
import MBProgressHUD

class LocalPostDetailViewController: ASDKViewController<LocalPostDetailViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    var commentDataSource: RxASTableSectionedAnimatedDataSource<LocalCommentListSection>!
    
    var localPost: LocalPost? = nil
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
        self.setupDataSource()
        reactor = LocalPostDetailViewReactor()
        
        self.setupData()
    }
    
    private func setupDataSource() {
        commentDataSource = RxASTableSectionedAnimatedDataSource<LocalCommentListSection>(
            configureCellBlock: { _, _, _, item in
                switch item {
                    case .localPost(let post):
                        return { LocalContentCell(post: post) }
                        
                    case .localComment(let comment):
                        return {
                            let cell = LocalCommentCell(comment: comment)
                            
                            cell.moreNode.rx.tap
                                .withUnretained(self)
                                .bind { owner, _ in
                                    owner.commentAlret(idx: comment.idx)
                                }.disposed(by: cell.disposeBag)
                            
                            return cell
                        }
                }
        })
    }
    
    private func setupData() {
        Observable.concat([
            .just(.fetchUserInfo),
            .just(.fetchLocalComments(idx))
        ]).bind(to: reactor!.action)
        .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
        self.addKeyboardNotifications()
        
        Observable.just(.fetchLocalPost(idx))
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotifications()
    }
    
    private func moveToEdit() {
        let vc = LocalPostAddViewController().then {
            $0.localPost = self.localPost
        }
        self.navigationController?.pushViewController(vc, animated: true)
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
            .action(title: "게시글 수정"),
            .action(title: "삭제", style: .destructive),
            .action(title: "취소", style: .cancel)
        ]
        
        UIAlertController
            .present(in: self, title: "게시글", message: "게시글 상태 변경", style: .actionSheet, actions: actions)
            .withUnretained(self)
            .subscribe { owner, value in
                switch (value) {
                    case 0:
                        owner.moveToEdit()
                    case 1:
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
            $0.backgroundColor = .systemBackground
            $0.localPostCommentNode.commentInputNode.commentField.placeholder = "따뜻한 댓글을 입력해주세요 :)"
        }
    }
    
    func loadNode() {
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
        
        node.localPostCommentNode.commentInputNode.sendNode.rx.tap
            .withUnretained(self)
            .map { .sendComment($0.0.idx) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        node.localPostCommentNode.commentInputNode.commentField.rx.text.orEmpty
            .map { .comment($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
                
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
        
        let post = reactor.state.map { $0.localPost }
            .filter { $0 != nil }
            .map { $0! }
            .share()
        
        post.withUnretained(self)
            .bind { $0.0.localPost = $0.1 }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            post, reactor.state.map { $0.localComments }
        ) { post, comments -> [LocalCommentListSection] in
            
            var sections: [LocalCommentListSectionItem] = []
            sections.append(LocalCommentListSectionItem.localPost(post))
            sections.append(contentsOf: comments.map { LocalCommentListSectionItem.localComment($0) })
            
            return [LocalCommentListSection.localComment(localComments: sections)]
        }.bind(to: node.tableNode.rx.items(dataSource: commentDataSource))
        .disposed(by: disposeBag)
        
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
