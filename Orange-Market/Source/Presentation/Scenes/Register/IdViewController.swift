//
//  RegisterViewController.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/24.
//

import AsyncDisplayKit
import RxSwift
import MBProgressHUD

class IdViewController: ASDKViewController<InputContainerNode> {
    
    lazy var disposeBag: DisposeBag = DisposeBag()
    var registerRequest: RegisterRequest!
    
    var locationManager:CLLocationManager!
    
    private lazy var nextButton = UIButton().then {
        $0.setAttributedTitle("다음".toAttributed(color: .label, ofSize: 16), for: .normal)
        $0.tintColor = .label
    }
    
    override init() {
        super.init(node: InputContainerNode())
        self.initNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLocation()
        self.bind()
        self.registerRequest = RegisterRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar()
    }
    
    private func presentPwView() {
        guard !node.inputField.text!.isEmpty else {
            MBProgressHUD.errorShow("빈칸 없이 입력해주세요", from: self.view)
            return
        }
        self.registerRequest.userId = node.inputField.text
        
        let vc = PwViewController()
        vc.registerRequest = registerRequest
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupLocation() {
        locationManager = CLLocationManager()
        let coor = locationManager.location?.coordinate
        let latitude = coor?.latitude
        let longitude = coor?.longitude
        
        let findLocation: CLLocation = CLLocation(latitude: latitude ?? 0, longitude: longitude ?? 0)
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-kr")
        
        geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { (place, error) in
            if let address: [CLPlacemark] = place {
                self.registerRequest.city = address.last?.locality! ?? ""
                self.registerRequest.location =
                    "\(address.last?.administrativeArea ?? "") \(address.last?.locality! ?? "") \(address.last?.subLocality! ?? "")"
            }
        }
    }
}

extension IdViewController: ViewControllerType {
    
    func initNode() {
        self.node.do { container in
            container.backgroundColor = .systemBackground
            
            container.stepNode.attributedText = "STEP 1 OF 3".toAttributed(color: .gray, ofSize: 16)
            container.titleNode.attributedText = "아이디".toBoldAttributed(color: .label, ofSize: 18)
            container.inputField.placeholder = "아이디 입력"
        }
    }
    
    func loadNode() { }
    
    func setupNavigationBar() {
        self.navigationItem.do {
            $0.title = "아이디"
            $0.rightBarButtonItems = [
                UIBarButtonItem(customView: nextButton)
            ]
        }
    }
    
    func bind() {
        // input
        nextButton
            .rx.tap
            .bind(onNext: presentPwView)
            .disposed(by: disposeBag)
    }
}
