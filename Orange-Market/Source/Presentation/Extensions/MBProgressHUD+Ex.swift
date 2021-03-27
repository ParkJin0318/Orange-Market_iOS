//
//  MBProgressHUD.swift
//  Orange-Market
//
//  Created by 박진 on 2021/03/15.
//

import MBProgressHUD

extension MBProgressHUD {
  
    static func loading(from fromView: UIView?) {
        guard let view = fromView else { return }
        
        MBProgressHUD.hide(for: view, animated: true)
        let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        progressHUD.mode = .indeterminate
        progressHUD.label.text = "로딩중"
    }
    
    static func errorShow(_ message: String, from fromView: UIView?) {
        guard let view = fromView else { return }
        
        MBProgressHUD.hide(for: view, animated: true)
        let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        progressHUD.mode = .determinate
        progressHUD.label.text = message
        progressHUD.hide(animated: true, afterDelay: 1)
    }
    
    static func successShow(_ message: String, from fromView: UIView?) {
        guard let view = fromView else { return }
        
        MBProgressHUD.hide(for: view, animated: true)
        let progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        progressHUD.mode = .customView
        progressHUD.customView = UIImageView(image: UIImage(systemName: "checkmark"))
        progressHUD.label.text = message
        progressHUD.isSquare = true
        progressHUD.hide(animated: true, afterDelay: 1)
    }
}

