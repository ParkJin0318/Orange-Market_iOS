//
//  LoginViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/12.
//

import AsyncDisplayKit
import RxSwift
import MBProgressHUD
import CoreLocation
import ReactorKit

class LoginViewController: ASDKViewController<LoginViewContainer> & View {
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    
    var locationManager: CLLocationManager!

    override init() {
        super.init(node: LoginViewContainer())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadNode()
        reactor = LoginViewReactor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
        self.getPermission()
    }
    
    private func presentHomeView() {
        self.present(TabBarController().then {
            $0.modalPresentationStyle = .fullScreen
            $0.modalTransitionStyle = .crossDissolve
        }, animated: true)
    }
    
    private func presentRegisterView() {
        switch locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                self.navigationController?.pushViewController(IdViewController(), animated: true)
            case .restricted, .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .denied:
                Observable.just("설정에서 위치 권한을 허용해주세요")
                    .bind(to: view.rx.error)
                    .disposed(by: disposeBag)
            default:
                locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension LoginViewController: CLLocationManagerDelegate {
    
    private func getPermission() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
}

extension LoginViewController: ViewControllerType {
    
    func initNode() {
        self.node.do {
            $0.backgroundColor = .systemBackground
            
            $0.imageNode.image = UIImage(named: "security")
            $0.descriptionNode.attributedText =
                "오렌지마켓은 아이디로 로그인해요.\n개인정보는 안전하게 보관되며\n어디에도 공개되지 않아요." .toAttributed(color: .label, ofSize: 16)
            $0.idField.placeholder = "아이디 입력"
            $0.passwordField.placeholder = "비밀번호 입력"
            $0.loginNode.setTitle("로그인", with: .boldSystemFont(ofSize: 18), with: .systemBackground, for: .normal)
            $0.guideNode.attributedText = "오렌지마켓은 처음인가요?".toAttributed(color: .label, ofSize: 15)
            $0.registerNode.setAttributedTitle("가입하기".toBoldAttributed(color: .label, ofSize: 15), for: .normal)
        }
    }
    
    func loadNode() { }
    
    func setupNavigationBar() {
        self.navigationItem.title = "로그인"
        self.navigationController?.do {
            $0.isNavigationBarHidden = false
            $0.navigationBar.barTintColor = .systemBackground
            $0.navigationBar.tintColor = .black
        }
    }
    
    func bind(reactor: LoginViewReactor) {
        // Action
        node.idField.rx.text.orEmpty
            .map { .userId($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        node.passwordField.rx.text.orEmpty
            .map { .userPw($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        node.loginNode.rx.tap
            .map { .login }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        node.registerNode.rx.tap
            .withUnretained(self)
            .bind { $0.0.presentRegisterView() }
            .disposed(by: disposeBag)
        
        // State
        let isEnabled = reactor.state
            .map { $0.isEnabledLogin }
            .share()
        
        isEnabled
            .bind(to: node.loginNode.rx.isEnabled)
            .disposed(by: disposeBag)
        
        isEnabled
            .map { $0 ? UIColor.primaryColor() : UIColor.lightGray }
            .bind(to: node.loginNode.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isSuccessLogin }
            .filter { $0 }
            .withUnretained(self)
            .bind { $0.0.presentHomeView() }
            .disposed(by: disposeBag)
        
        let progressHUD = MBProgressHUD()
        progressHUD.mode = .indeterminate
        progressHUD.label.text = "로딩중"
        
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
