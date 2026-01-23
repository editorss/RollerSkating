//
//  rs_WelcomeViewController.swift
//  RollerSkating
//
//  登录欢迎界面 - 全屏背景图 + Start按钮 + 协议勾选
//

import UIKit
import SnapKit
import SVProgressHUD
import Alamofire

class rs_WelcomeViewController: UIViewController {
    
    // MARK: - UI Elements
    
    /// 全屏背景图（包含除按钮外的所有元素）
    private let rs_bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "登录界面背景图")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    /// Start按钮
    private let rs_startBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "start按钮"), for: .normal)
        btn.alpha = 0.4
        btn.isEnabled = false
        return btn
    }()
    
    /// 勾选按钮
    private let rs_checkBox: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "square"), for: .normal)
        btn.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        btn.tintColor = UIColor(hex: "#9CFF3A")
        return btn
    }()
    
    /// 协议文案
    private let rs_agreementLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        let text = "I have read and agree to the User Agreement and Privacy Policy"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor(white: 0.7, alpha: 1), range: NSRange(location: 0, length: text.count))
        
        if let userRange = text.range(of: "User Agreement") {
            let nsRange = NSRange(userRange, in: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor(hex: "#9CFF3A"), range: nsRange)
        }
        if let privacyRange = text.range(of: "Privacy Policy") {
            let nsRange = NSRange(privacyRange, in: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor(hex: "#9CFF3A"), range: nsRange)
        }
        
        lbl.attributedText = attributedString
        lbl.isUserInteractionEnabled = true
        return lbl
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
        
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_startBtn)
        view.addSubview(rs_checkBox)
        view.addSubview(rs_agreementLabel)
        
        // 背景图铺满全屏
        rs_bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 协议勾选框
        rs_checkBox.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.size.equalTo(24)
        }
        
        // 协议文案
        rs_agreementLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_checkBox.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-24)
            make.centerY.equalTo(rs_checkBox)
        }
        
        // Start按钮在协议上方
        rs_startBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalTo(rs_checkBox.snp.top).offset(-20)
            make.height.equalTo(56)
        }
    }
    
    private func rs_setupActions() {
        rs_startBtn.addTarget(self, action: #selector(rs_startTapped), for: .touchUpInside)
        rs_checkBox.addTarget(self, action: #selector(rs_checkBoxTapped), for: .touchUpInside)
        
        // 协议文案点击
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(rs_agreementTapped(_:)))
        rs_agreementLabel.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @objc private func rs_checkBoxTapped() {
        rs_checkBox.isSelected.toggle()
        rs_updateStartBtnState()
    }
    
    @objc private func rs_agreementTapped(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel, let text = label.attributedText?.string else { return }
        
        let userRange = (text as NSString).range(of: "User Agreement")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        
        let tapLocation = gesture.location(in: label)
        let textContainer = NSTextContainer(size: label.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode
        
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        textStorage.addLayoutManager(layoutManager)
        
        let characterIndex = layoutManager.characterIndex(for: tapLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if NSLocationInRange(characterIndex, userRange) {
            let vc = rs_AgreementViewController(type: .user)
            navigationController?.pushViewController(vc, animated: true)
        } else if NSLocationInRange(characterIndex, privacyRange) {
            let vc = rs_AgreementViewController(type: .privacy)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func rs_updateStartBtnState() {
        let isEnabled = rs_checkBox.isSelected
        rs_startBtn.isEnabled = isEnabled
        rs_startBtn.alpha = isEnabled ? 1.0 : 0.4
    }
    
    @objc private func rs_startTapped() {
        guard rs_checkBox.isSelected else {
            SVProgressHUD.showError(withStatus: "Please agree to the terms")
            return
        }
        
        // 模拟网络请求（申请网络权限 + 登录 Loading）
        SVProgressHUD.show(withStatus: "Loading...")
        
        // 使用 Alamofire 进行网络请求（触发网络权限）
        AF.request("https://www.apple.com").response { [weak self] response in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                SVProgressHUD.dismiss()
                // 直接跳转到PlayStyle页面，跳过Gender和Age选择（App Store审核要求）
                let playStyleVC = rs_PlayStyleViewController()
                self?.navigationController?.pushViewController(playStyleVC, animated: true)
            }
        }
    }
}
