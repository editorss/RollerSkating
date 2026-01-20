//
//  rs_MessageListViewController.swift
//  RollerSkating
//
//  消息列表界面
//

import UIKit
import SnapKit

class rs_MessageListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var rs_conversations: [rs_Conversation] = []
    
    // MARK: - UI Elements
    
    /// 背景图
    private let rs_bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ai分析界面全屏背景图")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    /// 返回按钮
    private let rs_backBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "全局返回按钮"), for: .normal)
        return btn
    }()
    
    /// 标题
    private let rs_titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Message"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        lbl.textAlignment = .center
        return lbl
    }()
    
    /// 消息列表
    private let rs_tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    /// 空数据占位图
    private let rs_emptyImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "No data加人物")
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupActions()
        rs_loadMessages()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rs_loadMessages()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Setup
    
    private func rs_setupUI() {
        view.backgroundColor = UIColor(red: 18/255, green: 0/255, blue: 48/255, alpha: 1)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_backBtn)
        view.addSubview(rs_titleLabel)
        view.addSubview(rs_tableView)
        view.addSubview(rs_emptyImageView)
        
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
            make.top.equalTo(rs_backBtn.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        rs_emptyImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        rs_setupTableView()
    }
    
    private func rs_setupTableView() {
        rs_tableView.delegate = self
        rs_tableView.dataSource = self
        rs_tableView.register(rs_MessageCell.self, forCellReuseIdentifier: rs_MessageCell.rs_identifier)
    }
    
    private func rs_setupActions() {
        rs_backBtn.addTarget(self, action: #selector(rs_backTapped), for: .touchUpInside)
    }
    
    // MARK: - Data
    
    private func rs_loadMessages() {
        rs_conversations = rs_LocalJSONStore.shared.rs_loadConversations()
        
        rs_updateEmptyState()
        rs_tableView.reloadData()
    }
    
    private func rs_updateEmptyState() {
        let isEmpty = rs_conversations.isEmpty
        rs_tableView.isHidden = isEmpty
        rs_emptyImageView.isHidden = !isEmpty
    }
    
    // MARK: - Actions
    
    @objc private func rs_backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate & DataSource

extension rs_MessageListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rs_conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rs_MessageCell.rs_identifier, for: indexPath) as! rs_MessageCell
        let conversation = rs_conversations[indexPath.row]
        cell.rs_configure(with: conversation)
        cell.rs_onCall = { [weak self] in
            self?.rs_presentCall(conversation: conversation)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let conversation = rs_conversations[indexPath.row]
        let chatVC = rs_ChatViewController(conversationId: conversation.id)
        navigationController?.pushViewController(chatVC, animated: true)
    }
}

// MARK: - Message Cell

class rs_MessageCell: UITableViewCell {
    
    static let rs_identifier = "rs_MessageCell"
    
    private let rs_containerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 30/255, green: 20/255, blue: 50/255, alpha: 0.8)
        v.layer.cornerRadius = 16
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor(hex: "#7F55B2").cgColor
        return v
    }()
    
    private let rs_avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        return iv
    }()
    
    private let rs_userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return lbl
    }()
    
    private let rs_previewLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(white: 0.8, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.numberOfLines = 1
        return lbl
    }()
    
    private let rs_callBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "call按钮"), for: .normal)
        return btn
    }()

    var rs_onCall: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        rs_setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func rs_setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(rs_containerView)
        rs_containerView.addSubview(rs_avatarImageView)
        rs_containerView.addSubview(rs_userNameLabel)
        rs_containerView.addSubview(rs_previewLabel)
        rs_containerView.addSubview(rs_callBtn)
        
        rs_containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        rs_avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(48)
        }
        
        rs_callBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 36))
        }
        
        rs_userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_avatarImageView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(rs_callBtn.snp.leading).offset(-12)
            make.top.equalToSuperview().offset(16)
        }
        
        rs_previewLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_userNameLabel)
            make.trailing.lessThanOrEqualTo(rs_callBtn.snp.leading).offset(-12)
            make.top.equalTo(rs_userNameLabel.snp.bottom).offset(6)
            make.bottom.lessThanOrEqualToSuperview().offset(-16)
        }
    }
    
    func rs_configure(with model: rs_Conversation) {
        rs_avatarImageView.image = UIImage(named: model.avatar)
        rs_userNameLabel.text = model.peerName
        rs_previewLabel.text = model.lastMessage
        
        rs_callBtn.addTarget(self, action: #selector(rs_callTapped), for: .touchUpInside)
    }
    
    @objc private func rs_callTapped() {
        rs_onCall?()
    }
}

// MARK: - Call

private extension rs_MessageListViewController {
    func rs_presentCall(conversation: rs_Conversation) {
        let callVC = rs_CallViewController(
            peerName: conversation.peerName,
            peerAvatar: conversation.avatar
        )
        callVC.modalPresentationStyle = .fullScreen
        present(callVC, animated: true)
    }
}
