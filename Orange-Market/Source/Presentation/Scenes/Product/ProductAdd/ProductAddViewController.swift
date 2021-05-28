//
//  ProductAddViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/16.
//

import AsyncDisplayKit
import RxDataSources_Texture
import ReactorKit
import RxSwift
import RxCocoa
import MBProgressHUD

class ProductAddViewController: ASDKViewController<ProductAddViewContainer> & View {
    
    lazy var disposeBag = DisposeBag()
    
    lazy var categoryListViewController = CategoryListViewController()
    var product: Product? = nil
    
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
    
    let rxDataSource = RxASCollectionSectionedAnimatedDataSource<ProductImageListSection>(
        configureCellBlock: { _, _, _, item in
            switch item {
                case .image(let image):
                    return { ProductImageCell(image: image) }
            }
    })
    
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
        
        Observable.just(.fetchProduct(product))
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
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
    
    private func presentCategoryListView() {
        self.navigationController?.pushViewController(categoryListViewController, animated: true)
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
                    Observable.just(index)
                        .map { .removeImage($0) }
                        .bind(to: owner.reactor!.action)
                        .disposed(by: owner.disposeBag)
                }
            }.disposed(by: disposeBag)
    }
}

extension ProductAddViewController: ViewControllerType {
    
    func initNode() {
        self.node.do {
            $0.automaticallyManagesSubnodes = true
            $0.backgroundColor = .systemBackground
            
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
        closeButton.rx.tap
            .map { true }
            .bind(to: self.rx.pop)
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
        
        node.collectionNode.rx.itemSelected
            .withUnretained(self)
            .bind { owner, index in
                owner.removeImage(index: index.row)
            }.disposed(by: disposeBag)
        
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
            .map { $0.map { ProductImageListSectionItem.image($0) } }
            .map { [ProductImageListSection.image(images: $0)] }
            .bind(to: node.collectionNode.rx.items(dataSource: rxDataSource))
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

