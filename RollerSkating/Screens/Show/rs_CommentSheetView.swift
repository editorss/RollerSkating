//
//  rs_CommentSheetView.swift
//  RollerSkating
//
//  评论弹窗
//

import UIKit
import SnapKit

final class rs_CommentSheetView: UIView {
    
    private var rs_item: rs_SkateShowItem
    private var rs_onSend: ((String?) -> Void)?
    private var rs_comments: [rs_VideoComment]
    
    private let rs_backgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#000000", alpha: 0.6)
        return v
    }()
    
    private let rs_containerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#120030")
        v.layer.cornerRadius = 20
        v.clipsToBounds = true
        return v
    }()
    
    private let rs_titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Comment"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
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
    
    init(item: rs_SkateShowItem, onSend: ((String?) -> Void)?) {
        self.rs_item = item
        self.rs_onSend = onSend
        self.rs_comments = item.video.commentList
        super.init(frame: .zero)
        rs_setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func rs_present(in view: UIView, item: rs_SkateShowItem, onSend: @escaping (String?) -> Void) {
        let sheet = rs_CommentSheetView(item: item, onSend: onSend)
        view.addSubview(sheet)
        sheet.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        sheet.rs_show()
    }
    
    private func rs_setupUI() {
        addSubview(rs_backgroundView)
        addSubview(rs_containerView)
        
        rs_containerView.addSubview(rs_titleLabel)
        rs_containerView.addSubview(rs_tableView)
        rs_containerView.addSubview(rs_inputContainer)
        rs_inputContainer.addSubview(rs_inputTextField)
        rs_inputContainer.addSubview(rs_sendBtn)
        
        rs_backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rs_containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.55)
        }
        
        rs_titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        rs_tableView.snp.makeConstraints { make in
            make.top.equalTo(rs_titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(rs_inputContainer.snp.top).offset(-12)
        }
        
        rs_inputContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-12)
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
        
        rs_tableView.delegate = self
        rs_tableView.dataSource = self
        rs_tableView.register(rs_CommentCell.self, forCellReuseIdentifier: rs_CommentCell.rs_id)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(rs_backgroundTapped))
        rs_backgroundView.addGestureRecognizer(tap)
        rs_backgroundView.isUserInteractionEnabled = true
        
        rs_sendBtn.addTarget(self, action: #selector(rs_sendTapped), for: .touchUpInside)
        rs_inputTextField.addTarget(self, action: #selector(rs_sendTapped), for: .editingDidEndOnExit)
    }
    
    private func rs_show() {
        rs_containerView.transform = CGAffineTransform(translationX: 0, y: 300)
        rs_backgroundView.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.rs_containerView.transform = .identity
            self.rs_backgroundView.alpha = 1
        }
    }
    
    private func rs_hide() {
        UIView.animate(withDuration: 0.2, animations: {
            self.rs_containerView.transform = CGAffineTransform(translationX: 0, y: 300)
            self.rs_backgroundView.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    @objc private func rs_backgroundTapped() {
        rs_hide()
    }
    
    @objc private func rs_sendTapped() {
        guard let text = rs_inputTextField.text, !text.isEmpty else { return }
        rs_inputTextField.text = ""
        rs_onSend?(text)
        rs_hide()
    }
}

extension rs_CommentSheetView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rs_comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rs_CommentCell.rs_id, for: indexPath) as! rs_CommentCell
        cell.rs_configure(comment: rs_comments[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

final class rs_CommentCell: UITableViewCell {
    
    static let rs_id = "rs_CommentCell"
    
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
    
    func rs_configure(comment: rs_VideoComment) {
        rs_avatarImageView.image = UIImage(named: comment.avatar)
        rs_nameLabel.text = comment.userName
        rs_textLabelEx.text = comment.text
    }
}
