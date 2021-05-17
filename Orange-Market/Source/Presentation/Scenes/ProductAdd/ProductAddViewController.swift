//
//  ProductAddViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/16.
//

import AsyncDisplayKit
import ReactorKit
import RxSwift
import RxCocoa
import MBProgressHUD

class ProductAddViewController: ASDKViewController<ProductAddViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    
    lazy var categoryListViewController = CategoryListViewController()
    lazy var images: [String] = []
    
    var product: ProductDetail? = nil
    var category: Category? = nil
    
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
        super.init(node: ProductAddViewContainer())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNode()
        reactor = ProductAddViewReactor()
        
        if let reactor = self.reactor {
            Observable.just(.fetchProduct(product))
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
        self.setupCategory()
    }
    
    private func setupCategory() {
        let category = Observable.just(categoryListViewController.selectCategory)
            .filter { $0 != nil }
            .map { $0! }
            .share()
        
        category.map { $0.name }
            .map { .category($0) }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
        
        category.map { $0.idx }
            .map { .categoryIdx($0) }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    private func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func presentCategoryListView() {
        self.navigationController?.pushViewController(categoryListViewController, animated: true)
    }
}

extension ProductAddViewController: ViewControllerType {
    
    func initNode() {
        self.node.do {
            $0.automaticallyManagesSubnodes = true
            $0.backgroundColor = .systemBackground
            
            $0.collectionNode.delegate = self
            $0.collectionNode.dataSource = self
            
            $0.titleField.placeholder = "글 제목"
            $0.priceField.placeholder = "₩ 가격 입력"
            $0.contentField.placeholder = "게시글 내용 입력"
        }
    }
    
    func loadNode() { }
 
    func setupNavigationBar() {
        self.navigationItem.do {
            if (product == nil) {
                $0.title = "중고거래 글쓰기"
            } else {
                $0.title = "중고거래 글 수정하기"
            }
           
            $0.leftBarButtonItems = [
                UIBarButtonItem(customView: closeButton)
            ]
            $0.rightBarButtonItems = [
                UIBarButtonItem(customView: completeButton)
            ]
        }
    }
    
    func bind(reactor: ProductAddViewReactor) {
        // Action
        closeButton
            .rx.tap
            .bind(onNext: popViewController)
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .map { self.product == nil ? .saveProduct : .updateProduct }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        node.imagePickerNode.rx.tap
            .bind(onNext: presentImagePicker)
            .disposed(by: disposeBag)
        
        node.titleField.rx.text.orEmpty
            .map { .title($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        node.categorySelectNode.rx.tap
            .bind(onNext: presentCategoryListView)
            .disposed(by: disposeBag)

        node.priceField.rx.text.orEmpty
            .map { .price($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        node.contentField.rx.text.orEmpty
            .map { .content($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.category.toAttributed(color: .label, ofSize: 16) }
            .bind(to: node.categorySelectNode.nameNode.rx.attributedText)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.title }
            .bind(to: node.titleField.rx.text.orEmpty)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.price }
            .bind(to: node.priceField.rx.text.orEmpty)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.content }
            .bind(to: node.contentField.rx.text.orEmpty)
            .disposed(by: disposeBag)
            
        reactor.state.map { $0.images }
            .withUnretained(self)
            .filter { !$0.1.elementsEqual($0.0.images) }
            .bind { owner, value in
                owner.images = value
                owner.node.collectionNode.reloadData()
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.isSuccess }
            .distinctUntilChanged()
            .filter { $0 }
            .withUnretained(self)
            .bind { $0.0.popViewController() }
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

extension ProductAddViewController: UINavigationControllerDelegate & UIImagePickerControllerDelegate {
    
    private func presentImagePicker() {
        let imagePickerController = UIImagePickerController().then {
            $0.delegate = self
            $0.allowsEditing = true
            $0.sourceType = .photoLibrary
        }
        
        self.present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let reactor = self.reactor, let image = info[.originalImage] as? UIImage {
            Observable.just(.uploadImage(image))
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ProductAddViewController: ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(
            min: CGSize(width: 0, height: 0),
            max: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        )
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        removeImage(index: indexPath.row)
    }
    
    func removeImage(index: Int) {
        let actions: [UIAlertController.AlertAction] = [
            .action(title: "삭제", style: .destructive),
            .action(title: "아니요")
        ]
        
        UIAlertController
            .present(in: self, title: "사진 삭제", message: "사진을 삭제하시겠습니까?", style: .alert, actions: actions)
            .withUnretained(self)
            .subscribe { owner, value in
                if (value == 0) {
                    owner.images.remove(at: index)
                    owner.node.collectionNode.reloadData()
                }
            }.disposed(by: disposeBag)
    }
}

extension ProductAddViewController: ASCollectionDataSource {
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] in
            let item = self?.images[indexPath.row]
            let cell = ProductImageCell().then {
                $0.setupNode(url: item!)
                $0.imageNode.style.preferredSize = CGSize(width: 60, height: 60)
                $0.imageNode.cornerRadius = 5
            }
            return cell
        }
    }
}

