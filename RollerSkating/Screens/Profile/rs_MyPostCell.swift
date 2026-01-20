//
//  rs_MyPostCell.swift
//  RollerSkating
//
//  My Post Cell
//

import UIKit
import SnapKit

final class rs_MyPostCell: UITableViewCell {
    
    static let rs_id = "rs_MyPostCell"
    
    var rs_onDelete: (() -> Void)?
    
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
        lbl.textColor = UIColor(hex: "#B3B3B3")
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return lbl
    }()
    
    private let rs_followBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "关注按钮"), for: .normal)
        btn.setImage(UIImage(named: "已关注按钮"), for: .selected)
        btn.isHidden = true
        return btn
    }()
    
    private let rs_deleteBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "删除动态按钮"), for: .normal)
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
        rs_card.addSubview(rs_deleteBtn)
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
        
        rs_deleteBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(rs_avatar)
            make.size.equalTo(26)
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
        
        rs_deleteBtn.addTarget(self, action: #selector(rs_deleteTapped), for: .touchUpInside)
    }
    
    func rs_configure(post: rs_UserPost) {
        rs_avatar.image = UIImage.rs_load(post.avatar)
        rs_nameLabel.text = post.nickname
        rs_timeLabel.text = post.timeAgo
        rs_textLabelEx.text = post.content
        rs_postImageView.image = UIImage.rs_load(post.imageName)
        rs_commentLabel.text = "\(post.comments)"
        rs_likeLabel.text = "\(post.likes)"
        rs_likeBtn.isSelected = post.isLiked
    }
    
    @objc private func rs_deleteTapped() {
        rs_onDelete?()
    }
}
