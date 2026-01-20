//
//  rs_ProfileViewController.swift
//  RollerSkating
//
//  个人主页
//

import UIKit
import SnapKit

final class rs_ProfileViewController: UIViewController {
    
    private let rs_userId: String
    private var rs_user: rs_UserProfile
    
    private let rs_bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let rs_backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "全局返回按钮"), for: .normal)
        btn.backgroundColor = UIColor(hex: "#000000", alpha: 0.4)
        btn.layer.cornerRadius = 18
        return btn
    }()
    
    private let rs_reportBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "举报按钮"), for: .normal)
        btn.backgroundColor = UIColor(hex: "#000000", alpha: 0.4)
        btn.layer.cornerRadius = 18
        return btn
    }()
    
    private let rs_bottomBoard: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "个人主页底部视图背板")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let rs_nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return lbl
    }()
    
    private let rs_followersLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(white: 0.85, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return lbl
    }()
    
    private let rs_followingLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(white: 0.85, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return lbl
    }()

    private let rs_followBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "关注按钮"), for: .normal)
        btn.setImage(UIImage(named: "已关注按钮"), for: .selected)
        return btn
    }()
    
    private let rs_callBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "个人主页call按钮"), for: .normal)
        return btn
    }()
    
    private let rs_messageBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "个人主页Message按钮"), for: .normal)
        return btn
    }()
    
    init(user: rs_UserProfile) {
        self.rs_user = user
        self.rs_userId = user.id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupActions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rs_refreshUser()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func rs_setupUI() {

        view.backgroundColor = UIColor(red: 18/255, green: 0/255, blue: 48/255, alpha: 1)

        view.addSubview(rs_bgImageView)
        view.addSubview(rs_backBtn)
        view.addSubview(rs_reportBtn)
        view.addSubview(rs_bottomBoard)
        rs_bottomBoard.addSubview(rs_nameLabel)
        rs_bottomBoard.addSubview(rs_followersLabel)
        rs_bottomBoard.addSubview(rs_followingLabel)
        rs_bottomBoard.addSubview(rs_followBtn)
        view.addSubview(rs_callBtn)
        view.addSubview(rs_messageBtn)
        
        rs_bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rs_backBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        rs_reportBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        rs_bottomBoard.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(rs_bottomBoard.snp.width).multipliedBy(251.0 / 390.0)
        }
        
        rs_nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
        }

        rs_followBtn.snp.makeConstraints { make in
            make.leading.equalTo(rs_nameLabel.snp.trailing).offset(8)
            make.centerY.equalTo(rs_nameLabel)
            make.size.equalTo(24)
        }
        
        rs_followersLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_nameLabel)
            make.top.equalTo(rs_nameLabel.snp.bottom).offset(10)
        }
        
        rs_followingLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_followersLabel.snp.trailing).offset(16)
            make.centerY.equalTo(rs_followersLabel)
        }
        
        rs_callBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.top.equalTo(rs_followersLabel.snp.bottom).offset(16)
        }
        
        rs_messageBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
        rs_refreshUser()
    }
    
    private func rs_setupActions() {
        rs_backBtn.addTarget(self, action: #selector(rs_backTapped), for: .touchUpInside)
        rs_reportBtn.addTarget(self, action: #selector(rs_reportTapped), for: .touchUpInside)
        rs_callBtn.addTarget(self, action: #selector(rs_callTapped), for: .touchUpInside)
        rs_messageBtn.addTarget(self, action: #selector(rs_messageTapped), for: .touchUpInside)
        rs_followBtn.addTarget(self, action: #selector(rs_followTapped), for: .touchUpInside)
    }
    
    @objc private func rs_backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func rs_reportTapped() {
        rs_ReportSheetView.rs_present(in: view) { _ in }
    }
    
    @objc private func rs_callTapped() {
        let callVC = rs_CallViewController(peerName: rs_user.nickname, peerAvatar: rs_user.avatar)
        callVC.modalPresentationStyle = .fullScreen
        present(callVC, animated: true)
    }
    
    @objc private func rs_messageTapped() {
        let conversationId = rs_LocalJSONStore.shared.rs_getOrCreateConversation(
            peerName: rs_user.nickname,
            avatar: rs_user.avatar
        )
        let chatVC = rs_ChatViewController(conversationId: conversationId)
        navigationController?.pushViewController(chatVC, animated: true)
    }

    @objc private func rs_followTapped() {
        _ = rs_LocalJSONStore.shared.rs_toggleFollow(targetUserId: rs_userId)
        rs_refreshUser()
    }

    private func rs_refreshUser() {
        if let updated = rs_LocalJSONStore.shared.rs_getUserById(rs_userId) {
            rs_user = updated
        }
        rs_bgImageView.image = UIImage(named: rs_user.avatar)
        rs_nameLabel.text = rs_user.nickname
        rs_followersLabel.text = "Followers  \(rs_user.followers)"
        rs_followingLabel.text = "Following  \(rs_user.following)"
        rs_followBtn.isSelected = rs_user.isFollowed
    }
}
