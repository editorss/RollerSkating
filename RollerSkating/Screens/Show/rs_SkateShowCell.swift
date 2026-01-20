//
//  rs_SkateShowCell.swift
//  RollerSkating
//
//  Skate Show Cell
//

import UIKit
import SnapKit
import AVFoundation

final class rs_SkateShowCell: UICollectionViewCell {
    
    static let rs_id = "rs_SkateShowCell"
    
    private var rs_player: AVPlayer?
    private var rs_playerLayer: AVPlayerLayer?
    private var rs_item: rs_SkateShowItem?
    private var rs_isPlaying = true
    private var rs_endObserver: NSObjectProtocol?
    
    var rs_onLike: (() -> Void)?
    var rs_onComment: (() -> Void)?
    var rs_onReport: (() -> Void)?
    var rs_onFollow: (() -> Void)?
    var rs_onProfile: (() -> Void)?
    
    private let rs_videoContainer = UIView()
    
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
    
    private let rs_reportBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "举报按钮"), for: .normal)
        return btn
    }()
    
    private let rs_avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    private let rs_nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return lbl
    }()
    
    private let rs_followBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "关注按钮"), for: .normal)
        btn.setImage(UIImage(named: "已关注按钮"), for: .selected)
        return btn
    }()
    
    private let rs_captionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        rs_setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rs_stop()
        rs_playerLayer?.removeFromSuperlayer()
        rs_player = nil
        if let observer = rs_endObserver {
            NotificationCenter.default.removeObserver(observer)
            rs_endObserver = nil
        }
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window == nil {
            rs_stop()
        }
    }
    
    private func rs_setupUI() {
        contentView.addSubview(rs_videoContainer)
        contentView.addSubview(rs_likeBtn)
        contentView.addSubview(rs_likeLabel)
        contentView.addSubview(rs_commentBtn)
        contentView.addSubview(rs_commentLabel)
        contentView.addSubview(rs_reportBtn)
        contentView.addSubview(rs_avatarImageView)
        contentView.addSubview(rs_nameLabel)
        contentView.addSubview(rs_followBtn)
        contentView.addSubview(rs_captionLabel)
        
        rs_videoContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rs_reportBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().offset(120)
            make.size.equalTo(44)
        }
        
        rs_likeBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview().offset(-20)
            make.size.equalTo(44)
        }
        
        rs_likeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(rs_likeBtn)
            make.top.equalTo(rs_likeBtn.snp.bottom).offset(4)
        }
        
        rs_commentBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(rs_likeLabel.snp.bottom).offset(16)
            make.size.equalTo(44)
        }
        
        rs_commentLabel.snp.makeConstraints { make in
            make.centerX.equalTo(rs_commentBtn)
            make.top.equalTo(rs_commentBtn.snp.bottom).offset(4)
        }
        
        rs_avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-120)
            make.size.equalTo(40)
        }
        
        rs_nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_avatarImageView.snp.trailing).offset(8)
            make.centerY.equalTo(rs_avatarImageView)
        }
        
        rs_followBtn.snp.makeConstraints { make in
            make.leading.equalTo(rs_nameLabel.snp.trailing).offset(6)
            make.centerY.equalTo(rs_nameLabel)
            make.size.equalTo(24)
        }
        
        rs_captionLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_avatarImageView)
            make.trailing.equalToSuperview().offset(-80)
            make.top.equalTo(rs_avatarImageView.snp.bottom).offset(8)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(rs_togglePlay))
        contentView.addGestureRecognizer(tap)
        
        rs_likeBtn.addTarget(self, action: #selector(rs_likeTapped), for: .touchUpInside)
        rs_commentBtn.addTarget(self, action: #selector(rs_commentTapped), for: .touchUpInside)
        rs_reportBtn.addTarget(self, action: #selector(rs_reportTapped), for: .touchUpInside)
        rs_followBtn.addTarget(self, action: #selector(rs_followTapped), for: .touchUpInside)
        
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(rs_profileTapped))
        rs_avatarImageView.isUserInteractionEnabled = true
        rs_avatarImageView.addGestureRecognizer(avatarTap)
        
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(rs_profileTapped))
        rs_nameLabel.isUserInteractionEnabled = true
        rs_nameLabel.addGestureRecognizer(nameTap)
    }
    
    func rs_configure(item: rs_SkateShowItem) {
        rs_item = item
        rs_avatarImageView.image = UIImage(named: item.user.avatar)
        rs_nameLabel.text = item.user.nickname
        rs_followBtn.isSelected = item.user.isFollowed
        rs_captionLabel.text = item.video.caption
        
        rs_likeLabel.text = "\(item.video.likes)"
        rs_commentLabel.text = "\(item.video.comments)"
        rs_likeBtn.isSelected = item.video.isLiked
        
        rs_setupPlayer(videoName: item.video.videoName)
        rs_pause()
    }
    
    private func rs_setupPlayer(videoName: String) {
        guard let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") else { return }
        let player = AVPlayer(url: url)
        rs_player = player
        let layer = AVPlayerLayer(player: player)
        layer.frame = contentView.bounds
        layer.videoGravity = .resizeAspectFill
        rs_videoContainer.layer.addSublayer(layer)
        rs_playerLayer = layer
        rs_addLoopObserver()
    }
    
    private func rs_addLoopObserver() {
        if let observer = rs_endObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        guard let item = rs_player?.currentItem else { return }
        rs_endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] _ in
            self?.rs_player?.seek(to: .zero)
            if self?.rs_isPlaying == true {
                self?.rs_player?.play()
            }
        }
    }

    func rs_play() {
        rs_player?.play()
        rs_isPlaying = true
    }
    
    func rs_pause() {
        rs_player?.pause()
        rs_isPlaying = false
    }

    func rs_stop() {
        rs_player?.pause()
        rs_player?.seek(to: .zero)
        rs_isPlaying = false
    }
    
    @objc private func rs_togglePlay() {
        if rs_isPlaying {
            rs_pause()
        } else {
            rs_play()
        }
    }
    
    @objc private func rs_likeTapped() {
        rs_onLike?()
    }
    
    @objc private func rs_commentTapped() {
        rs_onComment?()
    }
    
    @objc private func rs_reportTapped() {
        rs_onReport?()
    }
    
    @objc private func rs_followTapped() {
        rs_onFollow?()
    }

    @objc private func rs_profileTapped() {
        rs_onProfile?()
    }
}
