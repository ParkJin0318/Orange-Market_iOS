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

class ProductAddViewController: ASDKViewController<ProductAddContainer> {
    
    lazy var disposeBag = DisposeBag()
    private lazy var viewModel = ProductAddViewModel()
    
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
        super.init(node: ProductAddContainer())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNode()
        self.setNavigation()
        self.bind()
    }
    
    private func setupNode() {
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
 
    private func setNavigation() {
        self.navigationItem.do {
            $0.title = "중고거래 글쓰기"
            $0.leftBarButtonItems = [
                UIBarButtonItem(customView: closeButton)
            ]
            $0.rightBarButtonItems = [
                UIBarButtonItem(customView: completeButton)
            ]
        }
    }
    
    private func bind() {
        // input
        closeButton.rx.tap
            .bind(onNext: popViewController)
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .bind(to: viewModel.input.tapComplete)
            .disposed(by: disposeBag)
        
        node.imagePickerNode.rx.tap
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
            .bind { [weak self] value in
                guard let self = self else { return }
                
                self.node.collectionNode.reloadData()
            }.disposed(by: disposeBag)
        
        viewModel.output.completedMessage
            .bind { [weak self] value in
                guard let self = self else { return }
                
                MBProgressHUD.hide(for: self.view, animated: true)
                MBProgressHUD.successShow(value, from: self.view)
            }.disposed(by: disposeBag)
    }
    
    private func popViewController() {
        self.navigationController?.popViewController(animated: true)
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
            let cell = ProductImageCell()
            cell.setupNode(url: item!)
            return cell
        }
    }
}

