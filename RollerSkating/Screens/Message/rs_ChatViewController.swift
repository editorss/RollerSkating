//
//  rs_ChatViewController.swift
//  RollerSkating
//
//  聊天详情界面
//

import UIKit
import SnapKit
import SVProgressHUD

class rs_ChatViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rs_conversationId: String
    private var rs_conversation: rs_Conversation?
    private var rs_messages: [rs_ConversationMessage] = []
    
    // MARK: - UI Elements
    
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
    
    private let rs_rightBellBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "举报按钮"), for: .normal)
        return btn
    }()
    
    private let rs_avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 34
        return iv
    }()
    
    private let rs_callBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "call按钮"), for: .normal)
        return btn
    }()
    
    private let rs_nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let rs_subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(white: 0.8, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private let rs_tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        return tv
    }()
    
    private let rs_inputContainer: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#2B1B4A")
        v.layer.cornerRadius = 24
        return v
    }()
    
    private let rs_inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Please enter..."
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tf.returnKeyType = .send
        return tf
    }()
    
    private let rs_sendBtn: UIButton = {
        let btn = UIButton(type: .custom)
        let image = UIImage(systemName: "paperplane.fill")
        btn.setImage(image, for: .normal)
        btn.tintColor = UIColor(hex: "#9CFF3A")
        return btn
    }()
    
    // MARK: - Init
    
    init(conversationId: String) {
        self.rs_conversationId = conversationId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupTableView()
        rs_setupActions()
        rs_loadConversation()
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
        view.addSubview(rs_rightBellBtn)
        view.addSubview(rs_avatarImageView)
        view.addSubview(rs_callBtn)
        view.addSubview(rs_nameLabel)
        view.addSubview(rs_subtitleLabel)
        view.addSubview(rs_tableView)
        view.addSubview(rs_inputContainer)
        rs_inputContainer.addSubview(rs_inputTextField)
        rs_inputContainer.addSubview(rs_sendBtn)
        
        rs_bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rs_backBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(44)
        }
        
        rs_rightBellBtn.snp.makeConstraints { make in
            make.centerY.equalTo(rs_backBtn)
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(44)
        }
        
        rs_avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(rs_backBtn.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(68)
        }
        
        rs_callBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(rs_avatarImageView.snp.bottom).offset(6)
            make.size.equalTo(CGSize(width: 96, height: 36))
        }
        
        rs_nameLabel.snp.makeConstraints { make in
            make.top.equalTo(rs_callBtn.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        rs_subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(rs_nameLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        rs_tableView.snp.makeConstraints { make in
            make.top.equalTo(rs_subtitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(rs_inputContainer.snp.top).offset(-12)
        }
        
        rs_inputContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
            make.height.equalTo(48)
        }
        
        rs_inputTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(rs_sendBtn.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
        }
        
        rs_sendBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
    }
    
    private func rs_setupTableView() {
        rs_tableView.delegate = self
        rs_tableView.dataSource = self
        rs_tableView.register(rs_ChatBubbleCell.self, forCellReuseIdentifier: rs_ChatBubbleCell.rs_identifier)
    }
    
    private func rs_setupActions() {
        rs_backBtn.addTarget(self, action: #selector(rs_backTapped), for: .touchUpInside)
        rs_rightBellBtn.addTarget(self, action: #selector(rs_reportTapped), for: .touchUpInside)
        rs_callBtn.addTarget(self, action: #selector(rs_callTapped), for: .touchUpInside)
        rs_sendBtn.addTarget(self, action: #selector(rs_sendTapped), for: .touchUpInside)
        rs_inputTextField.addTarget(self, action: #selector(rs_sendTapped), for: .editingDidEndOnExit)

        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(rs_profileTapped))
        rs_avatarImageView.isUserInteractionEnabled = true
        rs_avatarImageView.addGestureRecognizer(avatarTap)
    }
    
    // MARK: - Data
    
    private func rs_loadConversation() {
        let conversations = rs_LocalJSONStore.shared.rs_loadConversations()
        rs_conversation = conversations.first(where: { $0.id == rs_conversationId })
        rs_messages = rs_conversation?.messages ?? []
        
        rs_avatarImageView.image = UIImage(named: rs_conversation?.avatar ?? "默认avatar")
        rs_nameLabel.text = rs_conversation?.peerName ?? "User"
        rs_subtitleLabel.text = rs_conversation?.lastMessage ?? ""
        
        rs_LocalJSONStore.shared.rs_markConversationRead(conversationId: rs_conversationId)
        rs_tableView.reloadData()
        rs_scrollToBottom()
    }
    
    private func rs_scrollToBottom() {
        guard rs_messages.count > 0 else { return }
        let indexPath = IndexPath(row: rs_messages.count - 1, section: 0)
        rs_tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func rs_backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func rs_reportTapped() {
        rs_ReportSheetView.rs_present(in: view) { [weak self] item in
            guard let self else { return }
            if item.rs_isCancel {
                return
            }
            SVProgressHUD.show(withStatus: "Submitting...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                SVProgressHUD.dismiss()
                let message = item == .block ? "User blocked" : "Report submitted"
                SVProgressHUD.showSuccess(withStatus: message)
                if item == .block {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }

    @objc private func rs_callTapped() {
        let callVC = rs_CallViewController(
            peerName: rs_conversation?.peerName ?? "User",
            peerAvatar: rs_conversation?.avatar ?? "默认avatar"
        )
        callVC.modalPresentationStyle = .fullScreen
        present(callVC, animated: true)
    }

    @objc private func rs_profileTapped() {
        guard let name = rs_conversation?.peerName,
              let user = rs_LocalJSONStore.shared.rs_getUserByName(name) else { return }
        let profileVC = rs_ProfileViewController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc private func rs_sendTapped() {
        guard let text = rs_inputTextField.text, !text.isEmpty else { return }
        rs_inputTextField.text = ""
        
        rs_LocalJSONStore.shared.rs_appendMessage(conversationId: rs_conversationId, text: text, isFromMe: true)
        rs_loadConversation()
    }
}

// MARK: - UITableViewDelegate & DataSource

extension rs_ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rs_messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rs_ChatBubbleCell.rs_identifier, for: indexPath) as! rs_ChatBubbleCell
        cell.rs_configure(with: rs_messages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Chat Bubble Cell

class rs_ChatBubbleCell: UITableViewCell {
    
    static let rs_identifier = "rs_ChatBubbleCell"
    
    private let rs_bubbleView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 16
        return v
    }()
    
    private let rs_messageLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private var rs_bubbleLeading: Constraint?
    private var rs_bubbleTrailing: Constraint?
    
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
        
        contentView.addSubview(rs_bubbleView)
        rs_bubbleView.addSubview(rs_messageLabel)
        
        rs_bubbleView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.75)
            rs_bubbleLeading = make.leading.equalToSuperview().offset(24).constraint
            rs_bubbleTrailing = make.trailing.equalToSuperview().offset(-24).constraint
        }
        
        rs_messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(14)
        }
    }
    
    func rs_configure(with message: rs_ConversationMessage) {
        rs_messageLabel.text = message.text
        
        if message.isFromMe {
            rs_bubbleView.backgroundColor = UIColor(hex: "#C85CFF")
            rs_bubbleLeading?.deactivate()
            rs_bubbleTrailing?.activate()
        } else {
            rs_bubbleView.backgroundColor = UIColor(hex: "#6F5B86")
            rs_bubbleTrailing?.deactivate()
            rs_bubbleLeading?.activate()
        }
    }
}
