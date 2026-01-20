//
//  rs_FeedPostCell.swift
//  RollerSkating
//
//  Skate Feed Cell
//

import UIKit
import SnapKit

final class rs_FeedPostCell: UITableViewCell {
    
    static let rs_id = "rs_FeedPostCell"
    
    var rs_onFollow: (() -> Void)?
    var rs_onChat: (() -> Void)?
    var rs_onProfile: (() -> Void)?
    var rs_onReport: (() -> Void)?
    var rs_onLike: (() -> Void)?
    var rs_onComment: (() -> Void)?
    
    private let rs_card: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#2B1B4A")
        v.layer.cornerRadius = 18
        v.clipsToBounds = true
        return v
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
    
    private let rs_chatBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "chat按钮"), for: .normal)
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
    
    private let rs_reportBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "举报按钮"), for: .normal)
        return btn
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        rs_setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func rs_setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(rs_card)
        rs_card.addSubview(rs_avatar)
        rs_card.addSubview(rs_nameLabel)
        rs_card.addSubview(rs_timeLabel)
        rs_card.addSubview(rs_followBtn)
        rs_card.addSubview(rs_chatBtn)
        rs_card.addSubview(rs_textLabelEx)
        rs_card.addSubview(rs_postImageView)
        rs_card.addSubview(rs_reportBtn)
        rs_card.addSubview(rs_commentBtn)
        rs_card.addSubview(rs_commentLabel)
        rs_card.addSubview(rs_likeBtn)
        rs_card.addSubview(rs_likeLabel)
        
        rs_card.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        rs_avatar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.size.equalTo(40)
        }
        
        rs_nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_avatar.snp.trailing).offset(12)
            make.top.equalTo(rs_avatar)
        }
        
        rs_timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_nameLabel)
            make.top.equalTo(rs_nameLabel.snp.bottom).offset(2)
        }
        
        rs_followBtn.snp.makeConstraints { make in
            make.leading.equalTo(rs_nameLabel.snp.trailing).offset(8)
            make.centerY.equalTo(rs_nameLabel)
            make.size.equalTo(24)
        }
        
        rs_chatBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(rs_avatar)
        }
        
        rs_textLabelEx.snp.makeConstraints { make in
            make.leading.equalTo(rs_avatar)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(rs_avatar.snp.bottom).offset(12)
        }
        
        rs_postImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(rs_textLabelEx.snp.bottom).offset(12)
            make.height.equalTo(180)
        }
        
        rs_reportBtn.snp.makeConstraints { make in
            make.leading.equalTo(rs_postImageView)
            make.top.equalTo(rs_postImageView.snp.bottom).offset(10)
            make.size.equalTo(32)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        rs_likeBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(rs_reportBtn)
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
        
        rs_followBtn.addTarget(self, action: #selector(rs_followTapped), for: .touchUpInside)
        rs_chatBtn.addTarget(self, action: #selector(rs_chatTapped), for: .touchUpInside)
        rs_reportBtn.addTarget(self, action: #selector(rs_reportTapped), for: .touchUpInside)
        rs_likeBtn.addTarget(self, action: #selector(rs_likeTapped), for: .touchUpInside)
        rs_commentBtn.addTarget(self, action: #selector(rs_commentTapped), for: .touchUpInside)
        
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(rs_profileTapped))
        rs_avatar.isUserInteractionEnabled = true
        rs_avatar.addGestureRecognizer(avatarTap)
    }
    
    func rs_configure(item: rs_FeedItem) {
        rs_avatar.image = UIImage.rs_load(item.user.avatar)
        rs_nameLabel.text = item.user.nickname
        rs_timeLabel.text = item.post.timeAgo
        rs_followBtn.isSelected = item.user.isFollowed
        rs_textLabelEx.text = item.post.content
        rs_postImageView.image = UIImage.rs_load(item.post.imageName)
        rs_commentLabel.text = "\(item.post.comments)"
        rs_likeLabel.text = "\(item.post.likes)"
        rs_likeBtn.isSelected = item.post.isLiked
    }
    
    @objc private func rs_followTapped() {
        rs_onFollow?()
    }
    
    @objc private func rs_chatTapped() {
        rs_onChat?()
    }
    
    @objc private func rs_profileTapped() {
        rs_onProfile?()
    }

    @objc private func rs_reportTapped() {
        rs_onReport?()
    }

    @objc private func rs_likeTapped() {
        rs_onLike?()
    }

    @objc private func rs_commentTapped() {
        rs_onComment?()
    }
}
