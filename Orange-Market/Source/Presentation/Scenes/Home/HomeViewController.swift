//
//  HomeViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import AsyncDisplayKit
import RxSwift

class HomeViewController: ASDKViewController<HomeViewContainer> {
    
    lazy var disposeBag = DisposeBag()
    lazy var viewModel = HomeViewModel()
    
    private lazy var writeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        $0.tintColor = .label
    }
    
    override init() {
        super.init(node: HomeViewContainer())
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
        viewModel.getProducts()
    }
    
    private func presentProductAddView() {
        self.navigationController?.pushViewController(ProductAddViewController().then {
            $0.hidesBottomBarWhenPushed = true
        }, animated: true)
    }
    
    public func moveToStart(){
        AuthController.getInstance().logout()
        DispatchQueue.main.async {
            let vc = ASNavigationController(rootViewController: StartViewController()).then {
                $0.modalPresentationStyle = .fullScreen
                $0.modalTransitionStyle = .crossDissolve
            }
            self.navigationController?.present(vc, animated: true)
        }
    }
}

extension HomeViewController: ViewControllerType {
    
    func initNode() {
        self.node.do {
            $0.automaticallyManagesSubnodes = true
            $0.backgroundColor = .systemBackground
            
            $0.collectionNode.delegate = self
            $0.collectionNode.dataSource = self
        }
    }
    
    func loadNode() { }
    
    func setupNavigationBar() {
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: writeButton)
        ]
    }
    
    func bind() {
        // input
        writeButton.rx.tap
            .bind(onNext: presentProductAddView)
            .disposed(by: disposeBag)
        
        // output
        viewModel.output.city
            .withUnretained(self)
            .bind(onNext: { owner, value in
                owner.navigationController?.navigationBar.topItem?.title = value
                owner.node.collectionNode.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel.output.onFailureEvent
            .withUnretained(self)
            .bind { owner, value in
                owner.moveToStart()
            }.disposed(by: disposeBag)
    }
}

extension HomeViewController: ASCollectionDelegate {
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(
            min: CGSize(width: width, height: 0),
            max: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        )
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.output.productList[indexPath.row]
        
        let vc = ProductDetailViewController().then {
            $0.idx = item.idx
            $0.hidesBottomBarWhenPushed = true
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: ASCollectionDataSource {
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.productList.count
    }
        
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        return { [weak self] in
            let item = self?.viewModel.output.productList[indexPath.row]
            let cell = ProductCell()
            cell.setupNode(product: item!)
            return cell
        }
    }
}
