//
//  rs_MyProfileViewController.swift
//  RollerSkating
//
//  我的界面
//

import UIKit
import SnapKit
import SVProgressHUD

final class rs_MyProfileViewController: UIViewController {
    
    private var rs_currentUser: rs_UserProfile?
    private var rs_posts: [rs_UserPost] = []
    private var rs_tableHeight: Constraint?
    
    private let rs_scrollView = UIScrollView()
    private let rs_contentView = UIView()
    
    private let rs_tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let rs_bgImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ai分析界面全屏背景图")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let rs_msgBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "首页左上角消息通知按钮"), for: .normal)
        return btn
    }()
    
    private let rs_titleImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Profile")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let rs_editBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "编辑按钮"), for: .normal)
        return btn
    }()
    
    private let rs_settingBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "设置按钮"), for: .normal)
        return btn
    }()
    
    private let rs_avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 36
        iv.clipsToBounds = true
        return iv
    }()
    
    private let rs_nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return lbl
    }()
    
    private let rs_followersLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(hex: "#BFBFBF")
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return lbl
    }()
    
    private let rs_followingLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(hex: "#BFBFBF")
        lbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return lbl
    }()
    
    private let rs_walletBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "My Wallet"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    private let rs_statCard1 = rs_ProfileStatCardView(title: "Total Distance", value: "0 km")
    private let rs_statCard2 = rs_ProfileStatCardView(title: "Total Duration", value: "0h 0m")
    private let rs_statCard3 = rs_ProfileStatCardView(title: "Tricks Landed", value: "0")
    private let rs_statCard4 = rs_ProfileStatCardView(title: "Total Days", value: "0")
    
    private let rs_myPostTitleImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "My Post切图")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let rs_emptyPostImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "No data加人物")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rs_setupUI()
        rs_setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rs_reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private func rs_setupUI() {
        view.addSubview(rs_bgImageView)
        view.addSubview(rs_scrollView)
        rs_scrollView.addSubview(rs_contentView)
        
        rs_contentView.addSubview(rs_msgBtn)
        rs_contentView.addSubview(rs_titleImageView)
        rs_contentView.addSubview(rs_editBtn)
        rs_contentView.addSubview(rs_settingBtn)
        rs_contentView.addSubview(rs_avatarImageView)
        rs_contentView.addSubview(rs_nameLabel)
        rs_contentView.addSubview(rs_followersLabel)
        rs_contentView.addSubview(rs_followingLabel)
        rs_contentView.addSubview(rs_walletBtn)
        rs_contentView.addSubview(rs_statCard1)
        rs_contentView.addSubview(rs_statCard2)
        rs_contentView.addSubview(rs_statCard3)
        rs_contentView.addSubview(rs_statCard4)
        rs_contentView.addSubview(rs_myPostTitleImageView)
        rs_contentView.addSubview(rs_tableView)
        rs_contentView.addSubview(rs_emptyPostImageView)
        
        rs_bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        rs_scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        rs_contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(rs_scrollView)
        }
        rs_msgBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(44)
        }
        rs_titleImageView.snp.makeConstraints { make in
            make.centerY.equalTo(rs_msgBtn)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(24)
        }
        rs_editBtn.snp.makeConstraints { make in
            make.top.equalTo(rs_titleImageView.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-70)
            make.size.equalTo(36)
        }
        rs_settingBtn.snp.makeConstraints { make in
            make.centerY.equalTo(rs_editBtn)
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(36)
        }
        rs_avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(rs_msgBtn.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(72)
        }
        rs_nameLabel.snp.makeConstraints { make in
            make.top.equalTo(rs_avatarImageView.snp.top).offset(6)
            make.leading.equalTo(rs_avatarImageView.snp.trailing).offset(12)
        }
        rs_followersLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_nameLabel)
            make.top.equalTo(rs_nameLabel.snp.bottom).offset(6)
        }
        rs_followingLabel.snp.makeConstraints { make in
            make.leading.equalTo(rs_followersLabel.snp.trailing).offset(16)
            make.centerY.equalTo(rs_followersLabel)
        }
        rs_walletBtn.snp.makeConstraints { make in
            make.top.equalTo(rs_avatarImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(rs_walletBtn.snp.width).multipliedBy(73.0 / 358.0)
        }
        rs_statCard1.snp.makeConstraints { make in
            make.top.equalTo(rs_walletBtn.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo((UIScreen.main.bounds.width - 48) / 2)
            make.height.equalTo(96)
        }
        rs_statCard2.snp.makeConstraints { make in
            make.top.equalTo(rs_statCard1)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(rs_statCard1)
        }
        rs_statCard3.snp.makeConstraints { make in
            make.top.equalTo(rs_statCard1.snp.bottom).offset(12)
            make.leading.equalTo(rs_statCard1)
            make.width.height.equalTo(rs_statCard1)
        }
        rs_statCard4.snp.makeConstraints { make in
            make.top.equalTo(rs_statCard3)
            make.trailing.equalTo(rs_statCard2)
            make.width.height.equalTo(rs_statCard1)
        }
        rs_myPostTitleImageView.snp.makeConstraints { make in
            make.top.equalTo(rs_statCard3.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(22)
        }
        rs_tableView.snp.makeConstraints { make in
            make.top.equalTo(rs_myPostTitleImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            rs_tableHeight = make.height.equalTo(0).constraint
            make.bottom.equalToSuperview().offset(-16)
        }
        rs_emptyPostImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(rs_myPostTitleImageView.snp.bottom).offset(40)
            make.width.equalTo(200)
            make.height.equalTo(180)
        }
        
        rs_tableView.delegate = self
        rs_tableView.dataSource = self
        rs_tableView.register(rs_MyPostCell.self, forCellReuseIdentifier: rs_MyPostCell.rs_id)
    }
    
    private func rs_setupActions() {
        rs_msgBtn.addTarget(self, action: #selector(rs_messageTapped), for: .touchUpInside)
        rs_editBtn.addTarget(self, action: #selector(rs_editTapped), for: .touchUpInside)
        rs_settingBtn.addTarget(self, action: #selector(rs_settingTapped), for: .touchUpInside)
        rs_walletBtn.addTarget(self, action: #selector(rs_walletTapped), for: .touchUpInside)
        
        // 关注和粉丝点击
        rs_followersLabel.isUserInteractionEnabled = true
        rs_followingLabel.isUserInteractionEnabled = true
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(rs_followersTapped))
        let followingTap = UITapGestureRecognizer(target: self, action: #selector(rs_followingTapped))
        rs_followersLabel.addGestureRecognizer(followersTap)
        rs_followingLabel.addGestureRecognizer(followingTap)
    }
    
    @objc private func rs_walletTapped() {
        let walletVC = rs_WalletViewController()
        navigationController?.pushViewController(walletVC, animated: true)
    }
    
    @objc private func rs_followersTapped() {
        let vc = rs_FollowListViewController(type: .followers)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func rs_followingTapped() {
        let vc = rs_FollowListViewController(type: .following)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func rs_reloadData() {
        rs_currentUser = rs_LocalJSONStore.shared.rs_getCurrentUser()
        rs_posts = rs_currentUser?.posts ?? []
        
        rs_avatarImageView.image = UIImage.rs_load(rs_currentUser?.avatar)
        rs_nameLabel.text = rs_currentUser?.nickname ?? "-"
        rs_followersLabel.text = "Followers  \(rs_currentUser?.followers ?? 0)"
        rs_followingLabel.text = "Following  \(rs_currentUser?.following ?? 0)"
        rs_emptyPostImageView.isHidden = !rs_posts.isEmpty
        let rowHeight: CGFloat = 420
        rs_tableHeight?.update(offset: rowHeight * CGFloat(rs_posts.count))
        rs_tableView.reloadData()
    }
    
    @objc private func rs_messageTapped() {
        let messageVC = rs_MessageListViewController()
        navigationController?.pushViewController(messageVC, animated: true)
    }
    
    @objc private func rs_editTapped() {
        let editVC = rs_EditProfileViewController()
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc private func rs_settingTapped() {
        let settingsVC = rs_SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
}

final class rs_ProfileStatCardView: UIView {
    
    private let rs_valueLabel = UILabel()
    private let rs_titleLabel = UILabel()
    private let rs_bar = UIView()
    
    init(title: String, value: String) {
        super.init(frame: .zero)
        rs_setupUI()
        rs_titleLabel.text = title
        rs_valueLabel.text = value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func rs_setupUI() {
        backgroundColor = UIColor(hex: "#2B1B4A")
        layer.cornerRadius = 16
        addSubview(rs_valueLabel)
        addSubview(rs_bar)
        addSubview(rs_titleLabel)
        
        rs_valueLabel.textColor = .white
        rs_valueLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        rs_titleLabel.textColor = UIColor(hex: "#CCCCCC")
        rs_titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        rs_bar.backgroundColor = UIColor(hex: "#9CFF3A")
        rs_bar.layer.cornerRadius = 2
        
        rs_valueLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        rs_bar.snp.makeConstraints { make in
            make.top.equalTo(rs_valueLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(56)
            make.height.equalTo(4)
        }
        rs_titleLabel.snp.makeConstraints { make in
            make.top.equalTo(rs_bar.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}

extension rs_MyProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rs_posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rs_MyPostCell.rs_id, for: indexPath) as! rs_MyPostCell
        let post = rs_posts[indexPath.row]
        cell.rs_configure(post: post)
        cell.rs_onDelete = { [weak self] in
            let alert = UIAlertController(title: "Delete", message: "Delete this post?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                rs_LocalJSONStore.shared.rs_deletePostForCurrentUser(postId: post.id)
                SVProgressHUD.showSuccess(withStatus: "Deleted")
                self?.rs_reloadData()
            }))
            self?.present(alert, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 420
    }
}
