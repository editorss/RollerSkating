//
//  rs_FollowListViewController.swift
//  RollerSkating
//
//  关注/粉丝列表
//

import UIKit
import SnapKit

enum rs_FollowListType {
    case followers
    case following
}

final class rs_FollowListViewController: UIViewController {
    
    private let rs_listType: rs_FollowListType
    private var rs_users: [rs_UserProfile] = []
    
    private let rs_bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ai分析界面全屏背景图")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let rs_backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "全局返回按钮"), for: .normal)
        return btn
    }()
    
    private let rs_titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let rs_tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    private let rs_emptyImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "No data加人物")
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    
    init(type: rs_FollowListType) {
        self.rs_listType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupTable()
        rs_loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private func rs_setupUI() {
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_backBtn)
        view.addSubview(rs_titleLabel)
        view.addSubview(rs_tableView)
        view.addSubview(rs_emptyImageView)
        
        rs_titleLabel.text = rs_listType == .followers ? "Followers" : "Following"
        
        rs_bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        rs_backBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(44)
        }
        rs_titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rs_backBtn)
            make.centerX.equalToSuperview()
        }
        rs_tableView.snp.makeConstraints { make in
            make.top.equalTo(rs_backBtn.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
        rs_emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(180)
        }
        
        rs_backBtn.addTarget(self, action: #selector(rs_backTapped), for: .touchUpInside)
    }
    
    private func rs_setupTable() {
        rs_tableView.delegate = self
        rs_tableView.dataSource = self
        rs_tableView.register(rs_FollowCell.self, forCellReuseIdentifier: rs_FollowCell.rs_id)
    }
    
    private func rs_loadData() {
        if rs_listType == .followers {
            // 粉丝列表：当前无粉丝
            rs_users = []
        } else {
            // 关注列表：获取已关注的用户
            let allUsers = rs_LocalJSONStore.shared.rs_loadUsers()
            rs_users = allUsers.filter { $0.isFollowed }
        }
        
        rs_emptyImageView.isHidden = !rs_users.isEmpty
        rs_tableView.isHidden = rs_users.isEmpty
        rs_tableView.reloadData()
    }
    
    @objc private func rs_backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension rs_FollowListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rs_users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rs_FollowCell.rs_id, for: indexPath) as! rs_FollowCell
        let user = rs_users[indexPath.row]
        cell.rs_configure(user: user)
        cell.rs_onChat = { [weak self] in
            let conversationId = rs_LocalJSONStore.shared.rs_getOrCreateConversation(peerName: user.nickname, avatar: user.avatar)
            let chatVC = rs_ChatViewController(conversationId: conversationId)
            self?.navigationController?.pushViewController(chatVC, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = rs_users[indexPath.row]
        let profileVC = rs_ProfileViewController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

// MARK: - Follow Cell

final class rs_FollowCell: UITableViewCell {
    
    static let rs_id = "rs_FollowCell"
    
    var rs_onChat: (() -> Void)?
    
    private let rs_avatar: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 28
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor(hex: "#FFD700").cgColor
        return iv
    }()
    
    private let rs_nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return lbl
    }()
    
    private let rs_chatBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "chat按钮"), for: .normal)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        rs_setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func rs_setup() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(rs_avatar)
        contentView.addSubview(rs_nameLabel)
        contentView.addSubview(rs_chatBtn)
        
        rs_avatar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(56)
        }
        rs_nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_avatar.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
        rs_chatBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        rs_chatBtn.addTarget(self, action: #selector(rs_chatTapped), for: .touchUpInside)
    }
    
    func rs_configure(user: rs_UserProfile) {
        rs_avatar.image = UIImage.rs_load(user.avatar)
        rs_nameLabel.text = user.nickname
    }
    
    @objc private func rs_chatTapped() {
        rs_onChat?()
    }
}
