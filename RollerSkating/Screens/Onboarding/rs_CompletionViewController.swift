//
//  rs_CompletionViewController.swift
//  RollerSkating
//
//  完成界面 - You're all set. Let's roll
//

import UIKit
import SnapKit

class rs_CompletionViewController: UIViewController {
    
    // MARK: - Properties (从前面页面传递)
    
    var rs_gender: String = ""
    var rs_age: Int = 18
    var rs_playStyle: String = ""
    var rs_stylePreference: String = ""
    
    // MARK: - UI Elements
    
    /// 全屏背景图
    private let rs_bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "go_skate背景图")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    /// GO SKATE按钮
    private let rs_goSkateBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "go_skate按钮"), for: .normal)
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupActions()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func rs_setupUI() {
        view.backgroundColor = UIColor(red: 18/255, green: 0/255, blue: 48/255, alpha: 1)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_goSkateBtn)
        
        // 背景图铺满全屏
        rs_bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // GO SKATE按钮居底部
        rs_goSkateBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.height.equalTo(56)
        }
    }
    
    private func rs_setupActions() {
        rs_goSkateBtn.addTarget(self, action: #selector(rs_goSkateTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func rs_goSkateTapped() {
        // 保存用户数据
        rs_UserManager.shared.rs_completeOnboarding(
            gender: rs_gender,
            age: rs_age,
            playStyle: rs_playStyle,
            stylePreference: rs_stylePreference
        )
        
        // 进入主界面
        let mainTabBar = rs_MainTabBarController()
        mainTabBar.modalPresentationStyle = .fullScreen
        
        // 切换根视图控制器
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = mainTabBar
            window.makeKeyAndVisible()
            
            // 添加过渡动画
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
}
