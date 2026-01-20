//
//  rs_AIMoveSelectionViewController.swift
//  RollerSkating
//
//  AI Move Recognition - 选择动作界面
//

import UIKit
import SnapKit
import AVFoundation
import SVProgressHUD

class rs_AIMoveSelectionViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rs_moves = [
        "Smooth Glide",
        "Double-Foot Spin",
        "Flow Turn",
        "T Brake",
        "Ollie Jump",
        "Cross Step"
    ]
    
    private var rs_selectedIndex: Int = 0
    
    // MARK: - UI Elements
    
    /// 返回按钮
    private let rs_backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "全局返回按钮"), for: .normal)
        return btn
    }()
    
    /// 标题
    private let rs_titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "AI move recognition"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        lbl.textAlignment = .center
        return lbl
    }()
    
    /// Choose文案图片
    private let rs_chooseImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Choose文案")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    /// 动作选项容器
    private let rs_optionsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        sv.distribution = .fillEqually
        return sv
    }()
    
    /// 动作选项按钮数组
    private var rs_optionButtons: [UIButton] = []
    
    /// Requires 100 coins 文案
    private let rs_coinsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Requires 100 coins"
        lbl.textColor = UIColor(white: 0.7, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.textAlignment = .center
        return lbl
    }()
    
    /// Start按钮
    private let rs_startBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "AI start按钮"), for: .normal)
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupOptions()
        rs_setupActions()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func rs_setupUI() {
        view.backgroundColor = UIColor(red: 18/255, green: 0/255, blue: 48/255, alpha: 1)
        
        view.addSubview(rs_backBtn)
        view.addSubview(rs_titleLabel)
        view.addSubview(rs_chooseImageView)
        view.addSubview(rs_optionsStackView)
        view.addSubview(rs_coinsLabel)
        view.addSubview(rs_startBtn)
        
        rs_backBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(44)
        }
        
        rs_titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rs_backBtn)
            make.centerX.equalToSuperview()
        }
        
        rs_chooseImageView.snp.makeConstraints { make in
            make.top.equalTo(rs_backBtn.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(70)
        }
        
        rs_optionsStackView.snp.makeConstraints { make in
            make.top.equalTo(rs_chooseImageView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        rs_startBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.height.equalTo(56)
        }
        
        rs_coinsLabel.snp.makeConstraints { make in
            make.bottom.equalTo(rs_startBtn.snp.top).offset(-16)
            make.centerX.equalToSuperview()
        }
    }
    
    private func rs_setupOptions() {
        for (index, move) in rs_moves.enumerated() {
            let btn = UIButton(type: .custom)
            btn.tag = index
            btn.setTitle(move, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            btn.setTitleColor(.white, for: .normal)
            btn.layer.cornerRadius = 12
            btn.clipsToBounds = true
            btn.addTarget(self, action: #selector(rs_optionTapped(_:)), for: .touchUpInside)
            
            rs_optionButtons.append(btn)
            rs_optionsStackView.addArrangedSubview(btn)
            
            btn.snp.makeConstraints { make in
                make.height.equalTo(56)
            }
        }
        
        rs_updateOptionStyles()
    }
    
    private func rs_updateOptionStyles() {
        for (index, btn) in rs_optionButtons.enumerated() {
            if index == rs_selectedIndex {
                btn.setBackgroundImage(UIImage(named: "动作选项选中紫色"), for: .normal)
            } else {
                btn.setBackgroundImage(UIImage(named: "动作选项未选中紫色"), for: .normal)
            }
        }
    }
    
    private func rs_setupActions() {
        rs_backBtn.addTarget(self, action: #selector(rs_backTapped), for: .touchUpInside)
        rs_startBtn.addTarget(self, action: #selector(rs_startTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func rs_backTapped() {
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func rs_optionTapped(_ sender: UIButton) {
        rs_selectedIndex = sender.tag
        rs_updateOptionStyles()
    }
    
    @objc private func rs_startTapped() {
        rs_checkCoinsAndProceed()
    }
    
    // MARK: - Coins Check
    
    private func rs_checkCoinsAndProceed() {
        let requiredCoins = 100
        if rs_UserManager.shared.rs_hasEnoughCoins(requiredCoins) {
            // 扣除金币
            _ = rs_UserManager.shared.rs_spendCoins(requiredCoins)
            rs_checkCameraPermission()
        } else {
            // 金币不足，弹窗提示
            let alert = UIAlertController(
                title: "Insufficient Coins",
                message: "This feature requires 100 coins. Would you like to purchase more coins?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Buy Coins", style: .default) { [weak self] _ in
                let walletVC = rs_WalletViewController()
                self?.navigationController?.pushViewController(walletVC, animated: true)
            })
            present(alert, animated: true)
        }
    }
    
    // MARK: - Camera Permission
    
    private func rs_checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            rs_openCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.rs_openCamera()
                    } else {
                        self?.rs_showPermissionDeniedAlert()
                    }
                }
            }
        case .denied, .restricted:
            rs_showPermissionDeniedAlert()
        @unknown default:
            break
        }
    }
    
    private func rs_showPermissionDeniedAlert() {
        let alert = UIAlertController(
            title: "Camera Permission Required",
            message: "AI Move Recognition needs camera access to record your skating moves so AI can analyze your technique and provide improvement suggestions. Please enable camera permission in Settings.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        
        present(alert, animated: true)
    }
    
    private func rs_openCamera() {
        let cameraVC = rs_CameraRecordViewController()
        cameraVC.rs_selectedMove = rs_moves[rs_selectedIndex]
        cameraVC.modalPresentationStyle = .fullScreen
        present(cameraVC, animated: true)
    }
}
