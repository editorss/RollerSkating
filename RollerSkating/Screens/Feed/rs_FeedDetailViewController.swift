//
//  rs_FeedDetailViewController.swift
//  RollerSkating
//
//  动态详情
//

import UIKit
import SnapKit
import SVProgressHUD

final class rs_FeedDetailViewController: UIViewController {
    
    private let rs_item: rs_FeedItem
    private let rs_onUpdate: (() -> Void)?
    private var rs_post: rs_UserPost
    
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
    
    private let rs_avatar: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        return iv
    }()
    
    private let rs_nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return lbl
    }()
    
    private let rs_timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(white: 0.7, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return lbl
    }()
    
    private let rs_followBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "关注按钮"), for: .normal)
        btn.setImage(UIImage(named: "已关注按钮"), for: .selected)
        return btn
    }()
    
    private let rs_reportBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "举报按钮"), for: .normal)
        return btn
    }()
    
    private let rs_textLabelEx: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let rs_postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        return iv
    }()
    
    private let rs_commentBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "评论按钮"), for: .normal)
        return btn
    }()
    
    private let rs_commentLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return lbl
    }()
    
    private let rs_likeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "未点赞"), for: .normal)
        btn.setImage(UIImage(named: "已点赞"), for: .selected)
        return btn
    }()
    
    private let rs_likeLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
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
    
    init(item: rs_FeedItem, onUpdate: (() -> Void)?) {
        self.rs_item = item
        self.rs_post = item.post
        self.rs_onUpdate = onUpdate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupTable()
        rs_setupActions()
        rs_refresh()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func rs_setupUI() {
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_backBtn)
        view.addSubview(rs_avatar)
        view.addSubview(rs_nameLabel)
        view.addSubview(rs_timeLabel)
        view.addSubview(rs_followBtn)
        view.addSubview(rs_reportBtn)
        view.addSubview(rs_textLabelEx)
        view.addSubview(rs_postImageView)
        view.addSubview(rs_commentBtn)
        view.addSubview(rs_commentLabel)
        view.addSubview(rs_likeBtn)
        view.addSubview(rs_likeLabel)
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
        
        rs_avatar.snp.makeConstraints { make in
            make.top.equalTo(rs_backBtn.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(40)
        }
        
        rs_nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_avatar.snp.trailing).offset(12)
            make.top.equalTo(rs_avatar)
        }
        
        rs_followBtn.snp.makeConstraints { make in
            make.leading.equalTo(rs_nameLabel.snp.trailing).offset(8)
            make.centerY.equalTo(rs_nameLabel)
            make.size.equalTo(24)
        }
        
        rs_timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_nameLabel)
            make.top.equalTo(rs_nameLabel.snp.bottom).offset(2)
        }
        
        rs_reportBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(rs_avatar)
            make.size.equalTo(32)
        }
        
        rs_textLabelEx.snp.makeConstraints { make in
            make.leading.equalTo(rs_avatar)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(rs_avatar.snp.bottom).offset(12)
        }
        
        rs_postImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(rs_textLabelEx.snp.bottom).offset(12)
            make.height.equalTo(200)
        }
        
        rs_likeBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(rs_postImageView.snp.bottom).offset(10)
            make.size.equalTo(24)
        }
        
        rs_likeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(rs_likeBtn.snp.leading).offset(-6)
            make.centerY.equalTo(rs_likeBtn)
        }
        
        rs_commentBtn.snp.makeConstraints { make in
            make.trailing.equalTo(rs_likeLabel.snp.leading).offset(-12)
            make.centerY.equalTo(rs_likeBtn)
            make.size.equalTo(24)
        }
        
        rs_commentLabel.snp.makeConstraints { make in
            make.trailing.equalTo(rs_commentBtn.snp.leading).offset(-6)
            make.centerY.equalTo(rs_commentBtn)
        }
        
        rs_tableView.snp.makeConstraints { make in
            make.top.equalTo(rs_commentBtn.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(rs_inputContainer.snp.top).offset(-12)
        }
        
        rs_inputContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
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
    
    private func rs_setupTable() {
        rs_tableView.delegate = self
        rs_tableView.dataSource = self
        rs_tableView.register(rs_PostCommentCell.self, forCellReuseIdentifier: rs_PostCommentCell.rs_id)
    }
    
    private func rs_setupActions() {
        rs_backBtn.addTarget(self, action: #selector(rs_backTapped), for: .touchUpInside)
        rs_followBtn.addTarget(self, action: #selector(rs_followTapped), for: .touchUpInside)
        rs_reportBtn.addTarget(self, action: #selector(rs_reportTapped), for: .touchUpInside)
        rs_likeBtn.addTarget(self, action: #selector(rs_likeTapped), for: .touchUpInside)
        rs_commentBtn.addTarget(self, action: #selector(rs_focusComment), for: .touchUpInside)
        rs_sendBtn.addTarget(self, action: #selector(rs_sendTapped), for: .touchUpInside)
        rs_inputTextField.addTarget(self, action: #selector(rs_sendTapped), for: .editingDidEndOnExit)
    }
    
    private func rs_refresh() {
        if let updated = rs_LocalJSONStore.shared.rs_getUserById(rs_item.user.id) {
            rs_post = updated.posts.first(where: { $0.id == rs_item.post.id }) ?? rs_post
        }
        rs_avatar.image = UIImage.rs_load(rs_item.user.avatar)
        rs_nameLabel.text = rs_item.user.nickname
        rs_timeLabel.text = rs_post.timeAgo
        rs_followBtn.isSelected = rs_item.user.isFollowed
        rs_textLabelEx.text = rs_post.content
        rs_postImageView.image = UIImage.rs_load(rs_post.imageName)
        rs_commentLabel.text = "\(rs_post.comments)"
        rs_likeLabel.text = "\(rs_post.likes)"
        rs_likeBtn.isSelected = rs_post.isLiked
        rs_tableView.reloadData()
        rs_onUpdate?()
    }
    
    @objc private func rs_backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func rs_followTapped() {
        _ = rs_LocalJSONStore.shared.rs_toggleFollow(targetUserId: rs_item.user.id)
        rs_refresh()
    }
    
    @objc private func rs_reportTapped() {
        rs_ReportSheetView.rs_present(in: view) { [weak self] item in
            guard let self else { return }
            if item == .block || item == .notInterested {
                rs_LocalJSONStore.shared.rs_blockUser(targetUserId: self.rs_item.user.id)
                SVProgressHUD.showSuccess(withStatus: "Hidden")
                self.navigationController?.popViewController(animated: true)
                self.rs_onUpdate?()
            } else if !item.rs_isCancel {
                SVProgressHUD.showSuccess(withStatus: "Report submitted")
            }
        }
    }
    
    @objc private func rs_likeTapped() {
        let willLike = !rs_post.isLiked
        rs_LocalJSONStore.shared.rs_updatePostLike(userId: rs_item.user.id, postId: rs_post.id, isLiked: willLike)
        SVProgressHUD.showSuccess(withStatus: willLike ? "Liked" : "Unliked")
        rs_refresh()
    }
    
    @objc private func rs_focusComment() {
        rs_inputTextField.becomeFirstResponder()
    }
    
    @objc private func rs_sendTapped() {
        guard let text = rs_inputTextField.text, !text.isEmpty else { return }
        rs_inputTextField.text = ""
        rs_LocalJSONStore.shared.rs_appendPostComment(
            userId: rs_item.user.id,
            postId: rs_post.id,
            userName: "Poppins",
            avatar: "默认avatar1",
            text: text
        )
        SVProgressHUD.showSuccess(withStatus: "Comment sent")
        rs_refresh()
    }
}

extension rs_FeedDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rs_post.commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rs_PostCommentCell.rs_id, for: indexPath) as! rs_PostCommentCell
        cell.rs_configure(comment: rs_post.commentList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

// MARK: - Post Comment Cell

final class rs_PostCommentCell: UITableViewCell {
    
    static let rs_id = "rs_PostCommentCell"
    
    private let rs_avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 18
        return iv
    }()
    
    private let rs_nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return lbl
    }()
    
    private let rs_textLabelEx: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(white: 0.85, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.numberOfLines = 2
        return lbl
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
        contentView.addSubview(rs_avatarImageView)
        contentView.addSubview(rs_nameLabel)
        contentView.addSubview(rs_textLabelEx)
        
        rs_avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(36)
        }
        
        rs_nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_avatarImageView.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(8)
        }
        
        rs_textLabelEx.snp.makeConstraints { make in
            make.leading.equalTo(rs_nameLabel)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(rs_nameLabel.snp.bottom).offset(4)
        }
    }
    
    func rs_configure(comment: rs_PostComment) {
        rs_avatarImageView.image = UIImage.rs_load(comment.avatar)
        rs_nameLabel.text = comment.userName
        rs_textLabelEx.text = comment.text
    }
}
