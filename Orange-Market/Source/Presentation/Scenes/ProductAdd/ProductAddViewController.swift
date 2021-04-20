//
//  ProductAddViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/16.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa
import MBProgressHUD

class ProductAddViewController: ASDKViewController<ProductAddViewContainer> {
    
    lazy var disposeBag = DisposeBag()
    lazy var viewModel = ProductAddViewModel()
    
    var product: ProductDetail? = nil
    
    let closeButton = UIButton().then {
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.label, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
    
    let completeButton = UIButton().then {
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
        self.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
    
    private func popViewController() {
        self.navigationController?.popViewController(animated: true)
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
    
    func bind() {
        let productData = Observable.just(product)
            .filter { $0 != nil }
            .share()
        
        productData
            .bind(to: viewModel.input.product)
            .disposed(by: disposeBag)
        
        productData.map { $0!.title }
            .bind(to: node.titleField.rx.text.orEmpty)
            .disposed(by: disposeBag)
        
        productData.map { $0!.price }
            .bind(to: node.priceField.rx.text.orEmpty)
            .disposed(by: disposeBag)
        
        productData.map { $0!.contents }
            .bind(to: node.contentField.rx.text.orEmpty)
            .disposed(by: disposeBag)
        
        productData.map { $0!.imageList }
            .withUnretained(self)
            .bind { $0.0.viewModel.output.imageList = $0.1 }
            .disposed(by: disposeBag)
        
        // input
        closeButton
            .rx.tap
            .bind(onNext: popViewController)
            .disposed(by: disposeBag)
        
        if (product ==  nil) {
            completeButton
                .rx.tap
                .bind(to: viewModel.input.tapSave)
                .disposed(by: disposeBag)
        } else {
            completeButton
                .rx.tap
                .bind(to: viewModel.input.tapUpdate)
                .disposed(by: disposeBag)
        }
       
        node.imagePickerNode
            .rx.tap
            .bind(onNext: presentImagePicker)
            .disposed(by: disposeBag)
        
        node.titleField
            .rx.text.orEmpty
            .bind(to: viewModel.input.titleText)
            .disposed(by: disposeBag)

        node.priceField
            .rx.text.orEmpty
            .bind(to: viewModel.input.priceText)
            .disposed(by: disposeBag)
        
        node.contentField
            .rx.text.orEmpty
            .bind(to: viewModel.input.contentText)
            .disposed(by: disposeBag)
        
        // output
        viewModel.output.isReloadData
            .filter { $0 }
            .withUnretained(self)
            .bind { $0.0.node.collectionNode.reloadData() }
            .disposed(by: disposeBag)
        
        viewModel.output.completedMessage
            .withUnretained(self)
            .bind { owner, value in
                MBProgressHUD.hide(for: owner.view, animated: true)
                MBProgressHUD.successShow(value, from: owner.view)
                owner.popViewController()
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
        let image = info[.originalImage] as? UIImage
        viewModel.uploadImage(image: image!)
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
                    owner.viewModel.output.imageList.remove(at: index)
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
        return viewModel.output.imageList.count
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] in
            let item = self?.viewModel.output.imageList[indexPath.row]
            let cell = ProductImageCell().then {
                $0.setupNode(url: item!)
                $0.imageNode.style.preferredSize = CGSize(width: 60, height: 60)
                $0.imageNode.cornerRadius = 5
            }
            return cell
        }
    }
}

