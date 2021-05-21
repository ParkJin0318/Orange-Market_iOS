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
        self.addKeyboardNotifications()
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
    }
}

extension LocalPostDetailViewController: ViewControllerType {
    
    func initNode() {
        self.node.do {
            $0.automaticallyManagesSubnodes = true
            $0.backgroundColor = .systemBackground
            
            $0.localPostContentNode.tableNode.delegate = self
            $0.localPostContentNode.tableNode.dataSource = self
        }
    }
    
    func loadNode() {
        self.node.localPostContentNode.do {
            $0.tableNode.view.bounces = false
            $0.tableNode.view.alwaysBounceVertical = false
            $0.tableNode.view.showsVerticalScrollIndicator = false
            $0.view.showsVerticalScrollIndicator = false
            
            $0.tableNode.view.isScrollEnabled = false
            $0.tableNode.view.tableFooterView = UIView(frame: CGRect.zero)
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
        reactor.state.map { $0.localPost }
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: node.localPostContentNode.rx.post)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.localComments }
            .withUnretained(self)
            .filter { !$0.0.localComments.map { $0.toString() }.elementsEqual($0.1.map { $0.toString() }) }
            .bind { owner, value in
                owner.localComments = value
                owner.node.localPostContentNode.tableNode.reloadData()
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
            .withUnretained(self)
            .bind { owner, value in
                if (value) {
                    MBProgressHUD.loading(from: owner.view)
                } else {
                    MBProgressHUD.hide(for: owner.view, animated: true)
                }
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .filter { $0 != nil }
            .withUnretained(self)
            .bind { owner, value in
                MBProgressHUD.errorShow(value!, from: owner.view)
            }.disposed(by: disposeBag)
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
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        let count = localComments.count
        
        return count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] in
            guard let self = self else { return ASCellNode() }
            
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

extension LocalPostDetailViewController {
    
    func addKeyboardNotifications(){
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
        
    @objc func keyboardWillShow(_ noti: NSNotification){
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.node.localPostCommentNode.frame.origin.y -= keyboardHeight - 40
        }
    }

    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(_ noti: NSNotification){
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.node.localPostCommentNode.frame.origin.y += keyboardHeight - 40
        }
    }
}
